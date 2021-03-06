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

ActiveRecord::Schema.define(version: 20131209070624) do

  create_table "challenges", force: true do |t|
    t.integer  "challenger_id"
    t.integer  "challengee_id"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tables", force: true do |t|
    t.string   "initial_bag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "winner_id"
  end

  add_index "tables", ["uuid"], name: "index_tables_on_uuid", unique: true

  create_table "turns", force: true do |t|
    t.string   "type"
    t.integer  "turn_number"
    t.integer  "changed_turn_id"
    t.integer  "doer_user_id"
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "table_id"
  end

  add_index "turns", ["table_id", "turn_number"], name: "index_turns_on_table_id_and_turn_number", unique: true

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.integer  "high_score",               default: 0,                 null: false
    t.integer  "table_id"
    t.integer  "flip_request_turn_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_lobby_poll"
    t.float    "rating_mean",              default: 25.0
    t.float    "rating_deviation",         default: 8.333333333333334
  end

end
