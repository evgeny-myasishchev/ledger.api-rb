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

ActiveRecord::Schema.define(version: 20170927060627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :string, force: :cascade do |t|
    t.string "ledger_id", null: false
    t.string "name", null: false
    t.integer "display_order", null: false
    t.string "created_user_id", null: false
    t.string "currency_code", null: false
    t.string "unit"
    t.integer "balance", default: 0, null: false
    t.integer "pending_balance", default: 0, null: false
    t.boolean "is_closed", default: false, null: false
  end

  create_table "ledgers", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.string "created_user_id", null: false
    t.string "currency_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ledgers_users", id: false, force: :cascade do |t|
    t.string "ledger_id", null: false
    t.string "user_id", null: false
    t.boolean "is_owner", default: false, null: false
    t.index ["ledger_id"], name: "index_ledgers_users_on_ledger_id"
    t.index ["user_id"], name: "index_ledgers_users_on_user_id"
  end

  add_foreign_key "accounts", "ledgers"
  add_foreign_key "ledgers_users", "ledgers"
end
