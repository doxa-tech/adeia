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

ActiveRecord::Schema.define(version: 20151003150806) do

  create_table "adeia_action_permissions", force: :cascade do |t|
    t.integer  "action_id"
    t.integer  "permission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "adeia_action_permissions", ["action_id"], name: "index_adeia_action_permissions_on_action_id"
  add_index "adeia_action_permissions", ["permission_id"], name: "index_adeia_action_permissions_on_permission_id"

  create_table "adeia_actions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adeia_elements", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adeia_group_users", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "adeia_group_users", ["group_id"], name: "index_adeia_group_users_on_group_id"
  add_index "adeia_group_users", ["user_id"], name: "index_adeia_group_users_on_user_id"

  create_table "adeia_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adeia_permissions", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "element_id"
    t.integer  "permission_type"
    t.boolean  "read_right"
    t.boolean  "create_right"
    t.boolean  "update_right"
    t.boolean  "destroy_right"
    t.integer  "resource_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "adeia_permissions", ["element_id"], name: "index_adeia_permissions_on_element_id"
  add_index "adeia_permissions", ["owner_type", "owner_id"], name: "index_adeia_permissions_on_owner_type_and_owner_id"

  create_table "adeia_tokens", force: :cascade do |t|
    t.string   "token"
    t.boolean  "is_valid"
    t.integer  "permission_id"
    t.date     "exp_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "adeia_tokens", ["permission_id"], name: "index_adeia_tokens_on_permission_id"

end
