# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140107135625) do

  create_table "blocks", force: true do |t|
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color",       default: "black", null: false
    t.integer  "move_number"
    t.integer  "prev_move"
    t.integer  "column"
    t.integer  "row"
    t.boolean  "on_board"
  end

  create_table "dogs", force: true do |t|
    t.string   "name"
    t.date     "birthday"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body"
  end

end
