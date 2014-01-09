class AddBodyColumnToMemos < ActiveRecord::Migration
  def change
    add_column :memos, :body, :string
  end
end
