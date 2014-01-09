class BottomController < ApplicationController
  def index
    @memos = Memo.all
  end

  def update
  end
end
