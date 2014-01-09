# -*- coding: utf-8 -*-
class AddColumnToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :color, :string, default: "black", null: false
    add_column :blocks, :move_number, :integer
    add_column :blocks, :prev_move, :integer
    # 1〜19
    add_column :blocks, :column, :integer
    # 一〜十九
    add_column :blocks, :row, :integer
    # 現在盤上にあるかどうか
    add_column :blocks, :on_board, :boolean
  end
end
