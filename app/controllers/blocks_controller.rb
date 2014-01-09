# -*- coding: utf-8 -*-
class BlocksController < ApplicationController
  def get_number stone
    @board2[stone.column][stone.row]
  end

  def create
    # 制御はrails側で行う
    x = permitted_params[:x]
    y = permitted_params[:y]
    on_board = Block.on_board.where(x: x, y: y).first
    if on_board
      # 盤上の石の上に打とうとしている
      render json: { status: 'fail' }
    else
      # 空いているところに打とうとしている
      last_move = Block.create!(permitted_params)
      # 着手点周囲の生き死に情報判定
      check_life last_move.column, last_move.row, last_move.color
      #search
      #raise @numbers.inspect + "," + @breaze_nums.inspect
      dead_num = (@numbers - @breaze_nums - [get_number(last_move)])

      # 着手禁止点への着手
      # 「(自分の石を除く)死に石が存在しない」かつ「呼吸点番号に着手群番号が含まれない」
      if dead_num.size == 0 && !@breaze_nums.include?(get_number(last_move))
        last_move.destroy
        render json: { status: 'fail' }
      elsif dead_num.size > 0
        #raise dead_num.inspect
        dead_ids = []
        # 打ち上げられた石が存在
        (1..19).each do |i|
          (1..19).each do |j|
            unless i == last_move.column && j == last_move.row
              if dead_num.include?(@board2[i][j])
                @board[i][j].update_attributes(on_board: false)
                dead_ids << @board[i][j].id
              end
            end
          end
        end
        render json: { status: 'success', id: last_move.id, dead: dead_ids, numbers: @board2, breaze: @breaze }
      else
        render json: { status: 'success', id: last_move.id }
      end
    end
  end

  # 呼吸点を設定
  def set_breaze x, y, num
    if x.between?(1, 19) && y.between?(1, 19) && !@board[x][y]
      unless @breaze[x][y]
        @breaze[x][y] = []
      end
      @breaze[x][y] |= [num]
      @breaze_nums |= [num]
    end
  end

  # x, yが
  def check_life x, y, color
    @board  = Array.new(20).map{Array.new(20, nil)} # stones array
    @board2 = Array.new(20).map{Array.new(20, nil)} # number array
    @breaze = Array.new(20).map{Array.new(20, nil)} # 呼吸点 array
    @numbers = []
    @breaze_nums = []

    # 盤上の石を全てメモリに格納
    Block.on_board.each do |stone|
      @board[stone.column][stone.row] = stone
    end

    # 着手点と隣点をトレース
    trace x, y, color, 0
    trace x-1, y, nil, 1
    trace x+1, y, nil, 2
    trace x, y-1, nil, 3
    trace x, y+1, nil, 4
  end

  # 連結した石ごとにグルーピング
  def trace col, row, color, number
    return unless @board[col][row]
    return if @board2[col][row]
    # 色がnilでなく、異なった場合にはtraceしない
    return if color && @board[col][row].color != color
    @board2[col][row] = number
    # 色がnilなら新規の色
    color ||= @board[col][row].color
    # 群番号
    trace col+1, row, color, number
    trace col-1, row, color, number
    trace col, row+1, color, number
    trace col, row-1, color, number
    @numbers |= [number]
    # 四方の呼吸点
    set_breaze col+1, row, number
    set_breaze col-1, row, number
    set_breaze col, row+1, number
    set_breaze col, row-1, number
  end

  # 効率悪いけど全石を調べます
  # def search
  #   @board  = Array.new(20).map{Array.new(20, nil)} # stones array
  #   @board2 = Array.new(20).map{Array.new(20, nil)} # number array
  #   @breaze = Array.new(20).map{Array.new(20, nil)} # 呼吸点 array
  #   @numbers = []
  #   @breaze_nums = []

  #   # 盤上の石を全てメモリに格納
  #   Block.on_board.each do |stone|
  #     @board[stone.column][stone.row] = stone
  #   end

  #   counter = 0
  #   (1..19).each do |col|
  #     (1..19).each do |row|
  #       if this_stone = @board[col][row] # 石が有ったら
  #         unless @board2[col][row]
  #           # 群番号の初期化
  #           # TODO: やはりこの手法は姑息だった
  #           # 各種ケースに全然耐えられないので、完全に手法を変更します。
  #           if (col+1).between?(1,19) && @board2[col+1][row]
  #             # 一路右の石が既に番号を持っていたらその番号
  #             @board2[col][row] = @board2[col+1][row]
  #           else
  #             # そうでなければ番号なし
  #             @board2[col][row] = counter
  #             counter += 1
  #           end
  #         end
  #         number = @board2[col][row] # 石のnumberが決定

  #         # 四方の呼吸点
  #         set_breaze(col-1, row, number)
  #         set_breaze(col, row-1, number)
  #         set_breaze(col+1, row, number)
  #         set_breaze(col, row+1, number)

  #         # 隣接状態の確認: 同じ色の石が隣接していたら同じ番号
  #         stone = @board[col+1][row]
  #         @board2[col+1][row] = number if col+1 <= 19 && stone && stone.color == this_stone.color
  #         stone = @board[col][row+1]
  #         @board2[col][row+1] = number if row+1 <= 19 && stone && stone.color == this_stone.color
  #         @numbers |= [number]
  #       else # 石が無ければ
  #         # スルー
  #       end
  #     end
  #   end
  # end

  def update
    block = Block.find(params[:id])
    block.update_attributes!(permitted_params)
    render text: "OK"
  end

  def permitted_params
    params.require(:block).permit(:x,
                                  :y,
                                  :move_number,
                                  :color,
                                  :prev_move,
                                  :row,
                                  :column,
                                  :on_board)
  end
end
