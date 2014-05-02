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

ActiveRecord::Schema.define(version: 20140124192710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ideas", force: true do |t|
    t.string   "name"
    t.integer  "status",                          default: 1
    t.integer  "user_id"
    t.datetime "date_start"
    t.datetime "date_end"
    t.text     "summary"
    t.string   "local"
    t.float    "financial_value"
    t.float    "financial_value_sum_accumulated"
    t.string   "img_card"
    t.string   "video"
    t.string   "img_pg_1"
    t.string   "img_pg_2"
    t.string   "img_pg_3"
    t.string   "img_pg_4"
    t.text     "idea_content"
    t.text     "risks_challenges"
    t.boolean  "consulting_project",              default: false
    t.boolean  "consulting_creativity",           default: false
    t.boolean  "consulting_financial_structure",  default: false
    t.text     "consulting_specific"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ideas", ["user_id", "created_at"], name: "index_ideas_on_user_id_and_created_at", using: :btree

  create_table "investments", force: true do |t|
    t.integer  "recompense_id"
    t.integer  "user_id"
    t.float    "financial_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "investments", ["recompense_id", "created_at"], name: "index_investments_on_recompense_id_and_created_at", using: :btree
  add_index "investments", ["user_id", "created_at"], name: "index_investments_on_user_id_and_created_at", using: :btree

  create_table "recompenses", force: true do |t|
    t.string   "title"
    t.integer  "idea_id"
    t.float    "quantity"
    t.float    "financial_value"
    t.string   "summary"
    t.datetime "date_delivery"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recompenses", ["idea_id", "created_at"], name: "index_recompenses_on_idea_id_and_created_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "cpf",                     limit: 8
    t.date     "birth_date"
    t.string   "address"
    t.integer  "address_num"
    t.string   "complement"
    t.string   "district"
    t.integer  "cep",                     limit: 8
    t.string   "city"
    t.string   "region"
    t.string   "country"
    t.integer  "phone",                   limit: 8
    t.integer  "cell_phone",              limit: 8
    t.boolean  "notifications"
    t.boolean  "admin",                             default: false
    t.boolean  "facebook_association",              default: false
    t.boolean  "google_plus_association",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email", "created_at"], name: "index_users_on_email_and_created_at", unique: true, using: :btree
  add_index "users", ["remember_token", "created_at"], name: "index_users_on_remember_token_and_created_at", using: :btree

end
