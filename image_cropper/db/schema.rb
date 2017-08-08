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

ActiveRecord::Schema.define(version: 20170807211310) do

  create_table "project_crop_image_cords", force: :cascade do |t|
    t.integer "project_crop_image_id", limit: 4
    t.float   "x",                     limit: 24
    t.float   "y",                     limit: 24
  end

  add_index "project_crop_image_cords", ["project_crop_image_id"], name: "index_project_crop_image_cords_on_project_crop_image_id", using: :btree

  create_table "project_crop_images", force: :cascade do |t|
    t.integer "project_image_id", limit: 4
    t.integer "user_id",          limit: 4
    t.string  "image",            limit: 255
  end

  add_index "project_crop_images", ["user_id"], name: "index_project_crop_images_on_user_id", using: :btree

  create_table "project_images", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.string   "image",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "project_tags", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "project_tags", ["project_id"], name: "index_project_tags_on_project_id", using: :btree
  add_index "project_tags", ["tag_id"], name: "index_project_tags_on_tag_id", using: :btree

  create_table "project_users", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "tag_id",     limit: 4
  end

  add_index "project_users", ["project_id"], name: "index_project_users_on_project_id", using: :btree
  add_index "project_users", ["tag_id"], name: "index_project_users_on_tag_id", using: :btree
  add_index "project_users", ["user_id"], name: "index_project_users_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "crop_points", limit: 4
    t.boolean  "isactive",    limit: 1,     default: false
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name",                   limit: 255
    t.boolean  "is_active",              limit: 1,   default: false
    t.integer  "role_id",                limit: 4,   default: 3
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  add_foreign_key "project_crop_image_cords", "project_crop_images"
  add_foreign_key "project_crop_images", "users"
  add_foreign_key "project_tags", "projects"
  add_foreign_key "project_tags", "tags"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "users", "roles"
end
