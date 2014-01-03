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

ActiveRecord::Schema.define(version: 20140103230725) do

  create_table "comments", force: true do |t|
    t.text     "body",           null: false
    t.string   "timecode_start"
    t.string   "timecode_end"
    t.integer  "user_id",        null: false
    t.integer  "video_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", force: true do |t|
    t.string   "title",                           null: false
    t.integer  "revision_number",                 null: false
    t.boolean  "approved",        default: false, null: false
    t.integer  "project_id",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
