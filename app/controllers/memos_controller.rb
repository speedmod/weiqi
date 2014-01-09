class MemosController < ApplicationController
  def index
    @memos = Memo.all
  end

  def show
    @memos = Memo.all
  end

  def update
    @memo = Memo.find(params[:id])
    if @memo.update_attributes(permitted_params)
      status = 'success'
    else
      status = 'error'
    end

    render json: { status: status, data: @memo }
    # redirect_to memos_path
  end

  def new
    @memos = Memo.all
    @memos.last.hoge ||= 1
  end

  def permitted_params
    params.require(:memo).permit(:body)
  end
end
