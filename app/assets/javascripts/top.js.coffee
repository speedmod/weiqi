# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 参考サイト
# ★CoffeeScript入門
# http://www.oiax.jp/rails/coffee_script/coffee01.html
# ★基本操作逆引きリファレンス（CoffeeScript）
# http://kyu-mu.net/coffeescript/revref/
# 石を打ち上げる
# キーボードショートカットで石を配置する

# 手数
move = 1
# move_array = []
# 直前の手のid
prev_move = null
$ ->
  ###########
  # キー入力
  # キーコード：http://faq.creasus.net/04/0131/CharCode.html
  ###########
  # $(document).keydown (e)->
  #   last_move = $("#m#{move-1}")
  #   if e.which==37 # ←（矢印左キー）
  #     if last_move != null
  #       $("#m#{move-1}").remove()
  #       move -= 1
  #   if e.which==39 # →（矢印右キー）
  #     last_move = $("#m#{move-1}")
  #     if last_move != null
  #       $("#m#{move-1}").remove()
  #       move -= 1
  ###########
  # クリック
  ###########
  $("div#canvas").click (e) ->
    # （ダブルクリック時に起こる処理を記述）
    # イベント情報に基づきpositionOfNewBlockを実行
    try
      [x,y,row,column] = positionOfNewBlock (e)
      color = if move % 2 == 0 then "white" else "black"
      # Ajaxでポスト（URL: /blocks, 送信パラメータ {block: {x: y:})
      $.post '/blocks', block: { x: x, y: y, move_number: move, color: color, prev_move: prev_move, row: row, column: column, on_board: true }, (data) ->
        # Ajaxでのポスト成功時に起こる処理
        # ステータスがfailであれば何もしない
        return if data.status == 'fail'
        block = $("<div id='m#{data.id}' class='#{color}' style='left: #{x}px; top: #{y}px;'/>")
        #draggable(containment: "parent").css(position: "absolute")
        # e.target? イベントの対象となったオブジェクト。ここでは$('div#canvas')のこと？
        $(e.target).append(block)
        move += 1
        prev_move = data.id

        # 打ち上げた石を削除
        if data.dead
          for id in data.dead
            console.log "remove: #{id}"
            $("#m#{id}").remove()
        # デバッグ用コンソール出力
        if data.numbers
          # 群番号
          tmp = "|"
          console.log "BOARD2:\n"
          for col in [1..19]
            for row in [1..19]
              tmp += "#{data.numbers[col][row] ? '-'}|"
            tmp += "\n|"
          console.log tmp
        if data.breaze
          # 呼吸点番号
          tmp = "|"
          console.log "\nBREAZE:\n"
          for col in [1..19]
            for row in [1..19]
              tmp += "#{data.breaze[col][row] ? '-'}|"
            tmp += "\n|"
          console.log tmp
    catch e
      console.log e
  # $("div#canvas").click (e) ->
  #   # （ダブルクリック時に起こる処理を記述）
  #   # イベント情報に基づきpositionOfNewBlockを実行
  #   [x,y] = positionOfNewBlock (e)
  #   # Ajaxでポスト（URL: /blocks, 送信パラメータ {block: {x: y:})
  #   $.post '/blocks', block: { x: x, y: y }, (block_id) ->
  #     # Ajaxでのポスト成功時に起こる処理
  #     block = $("<div class='black' style='left: #{x}px; top: #{y}px;' />")
  #     #draggable(containment: "parent").css(position: "absolute")
  #     # e.target? イベントの対象となったオブジェクト。ここでは$('div#canvas')のこと？
  #     $(e.target).append(block)
  # divのblockクラスの要素をドラッグ可能とする。
  # $("div.block").draggable(containment: "parent").css(position: "absolute")

  # $(document).on "dragstop", "div.block", (e) ->
  #   block = $(e.target)
  #   blockId = block.data("blockId")
  #   x = parseInt(block.css("left"))
  #   y = parseInt(block.css("top"))
  #   $.ajax "/blocks/#{blockId}", type: "PUT", data: { block: { x: x, y: y } }
positionOfNewBlock = (e) ->
  unit_x = 26
  unit_y = 26
  topleft_x = 11
  topleft_y = 11
  canvas = $('div#canvas')
  #canvas = $(e.target)
  # console.log(e.pageX)
  # console.log(canvas.position().left)
  # console.log(e.pageY)

  x = e.pageX - canvas.position().left
  y = e.pageY - canvas.position().top

  for col in [0..18]
    if x < topleft_x + (unit_x/2) + unit_x * col #/ /
      x = topleft_x + unit_x * col - 12
      break
  for row in [0..18]
    if y < topleft_y + (unit_y/2) + unit_y * row
      y = topleft_y + unit_y * row - 12
      break
  #alert([x,y])
  #newmove = "(#{col+1},#{row+1})"
  #throw "Already moved." if newmove in move_array
  #move_array.push newmove
  #console.log(move_array)
  return [x, y, col+1, row+1]
