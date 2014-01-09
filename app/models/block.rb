class Block < ActiveRecord::Base
  scope :on_board, -> do
    where(on_board: true)
  end
end
