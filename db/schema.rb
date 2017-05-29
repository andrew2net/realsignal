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

ActiveRecord::Schema.define(version: 20170529201013) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "papers", force: :cascade do |t|
    t.string   "name",         limit: 8,                         null: false
    t.decimal  "tick_size",              precision: 6, scale: 5, null: false
    t.decimal  "tick_cost",              precision: 6, scale: 5, null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "price_format", limit: 5
  end

  create_table "portfolio_strategies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recom_signals", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "strategy_id", null: false
    t.integer  "signal_type", null: false
    t.datetime "datetime"
    t.index ["strategy_id", "datetime"], name: "index_recom_signals_on_strategy_id_and_datetime", unique: true, using: :btree
    t.index ["strategy_id"], name: "index_recom_signals_on_strategy_id", using: :btree
  end

  create_table "signal_papers", force: :cascade do |t|
    t.integer "recom_signal_id", null: false
    t.integer "paper_id",        null: false
    t.float   "price"
    t.index ["paper_id"], name: "index_signal_papers_on_paper_id", using: :btree
    t.index ["recom_signal_id", "paper_id"], name: "index_signal_papers_on_recom_signal_id_and_paper_id", unique: true, using: :btree
    t.index ["recom_signal_id"], name: "index_signal_papers_on_recom_signal_id", using: :btree
  end

  create_table "strategies", force: :cascade do |t|
    t.string   "name"
    t.integer  "leverage"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "portfolio_strategy_id"
    t.integer  "tool_id"
    t.index ["portfolio_strategy_id"], name: "index_strategies_on_portfolio_strategy_id", using: :btree
    t.index ["tool_id"], name: "index_strategies_on_tool_id", using: :btree
  end

  create_table "subscription_types", force: :cascade do |t|
    t.integer  "portid",                                          null: false
    t.string   "symid",       limit: 10,                          null: false
    t.decimal  "price",                  precision: 10, scale: 2, null: false
    t.text     "description"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "tool_papers", force: :cascade do |t|
    t.integer  "tool_id",                            null: false
    t.integer  "paper_id",                           null: false
    t.decimal  "volume",     precision: 4, scale: 1, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["paper_id"], name: "index_tool_papers_on_paper_id", using: :btree
    t.index ["tool_id"], name: "index_tool_papers_on_tool_id", using: :btree
  end

  create_table "tools", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "chat_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "signal_papers", "papers"
  add_foreign_key "signal_papers", "recom_signals", on_delete: :cascade
  add_foreign_key "strategies", "portfolio_strategies", on_delete: :restrict
  add_foreign_key "strategies", "tools", on_delete: :restrict
  add_foreign_key "tool_papers", "papers"
  add_foreign_key "tool_papers", "tools", on_delete: :cascade
end
