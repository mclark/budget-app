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

ActiveRecord::Schema.define(version: 20140330041855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "budgeted_cents"
  end

  add_index "categories", ["depth"], name: "index_categories_on_depth", using: :btree
  add_index "categories", ["lft"], name: "index_categories_on_lft", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["rgt"], name: "index_categories_on_rgt", using: :btree

  create_table "mint_accounts", force: true do |t|
    t.integer  "mint_id"
    t.integer  "imported_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mint_accounts", ["mint_id"], name: "index_mint_accounts_on_mint_id", unique: true, using: :btree

  create_table "mint_categories", force: true do |t|
    t.integer  "imported_id"
    t.string   "name"
    t.integer  "import_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mint_transactions", force: true do |t|
    t.integer  "mint_id"
    t.integer  "imported_id"
    t.date     "date"
    t.string   "description"
    t.string   "category"
    t.integer  "cents"
    t.boolean  "expense"
    t.string   "account"
    t.integer  "account_id"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mint_transactions", ["mint_id"], name: "index_mint_transactions_on_mint_id", unique: true, using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "account_id"
    t.integer  "category_id"
    t.integer  "transfer_id"
    t.string   "type"
    t.date     "date"
    t.string   "description"
    t.integer  "cents"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id", using: :btree
  add_index "transactions", ["category_id"], name: "index_transactions_on_category_id", using: :btree
  add_index "transactions", ["transfer_id"], name: "index_transactions_on_transfer_id", using: :btree

end
