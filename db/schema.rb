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

ActiveRecord::Schema.define(version: 20131004041525) do

  create_table "texts", force: true do |t|
    t.text     "body"
    t.boolean  "is_from_me"
    t.datetime "date"
    t.string   "number"
    t.string   "date_nice"
    t.string   "sender"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seconds"
    t.integer  "user_id"
  end

  add_index "texts", ["body"], name: "index_texts_on_body", using: :btree
  add_index "texts", ["date"], name: "index_texts_on_date", using: :btree
  add_index "texts", ["is_from_me"], name: "index_texts_on_is_from_me", using: :btree
  add_index "texts", ["name", "date"], name: "index_texts_on_name_and_date", using: :btree
  add_index "texts", ["name"], name: "index_texts_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
