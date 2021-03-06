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

ActiveRecord::Schema.define(version: 20140125222206) do

  create_table "comments", force: true do |t|
    t.text     "body",           null: false
    t.string   "timecode_start"
    t.string   "timecode_end"
    t.integer  "user_id",        null: false
    t.integer  "video_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id",                             null: false
    t.integer  "project_id",                          null: false
    t.string   "role",       default: "collaborator", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["project_id", "user_id"], name: "index_memberships_on_project_id_and_user_id", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "title",       null: false
    t.text     "description", null: false
    t.string   "status"
    t.date     "due_date"
    t.time     "due_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.string   "video_file",                      null: false
    t.integer  "revision_number",                 null: false
    t.boolean  "approved",        default: false, null: false
    t.integer  "project_id",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
