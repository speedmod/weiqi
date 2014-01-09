class TopController < ApplicationController
  def index
    Block.delete_all
    # @blocks = Block.all
  end
end
