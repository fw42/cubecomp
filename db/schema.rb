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

ActiveRecord::Schema.define(version: 20150517162903) do

  create_table "competitions", force: :cascade do |t|
    t.string   "name",                     limit: 255,                                            null: false
    t.string   "handle",                   limit: 255,                                            null: false
    t.string   "staff_email",              limit: 255,                                            null: false
    t.string   "staff_name",               limit: 255
    t.string   "city_name",                limit: 255,                                            null: false
    t.string   "city_name_short",          limit: 255
    t.text     "venue_address",            limit: 65535
    t.integer  "country_id",               limit: 4,                                              null: false
    t.boolean  "cc_staff",                 limit: 1,                              default: false
    t.boolean  "registration_open",        limit: 1,                              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delegate_user_id",         limit: 4
    t.integer  "owner_user_id",            limit: 4
    t.integer  "default_locale_id",        limit: 4
    t.string   "currency",                 limit: 255
    t.boolean  "published",                limit: 1,                              default: false
    t.decimal  "entrance_fee_competitors",               precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "entrance_fee_guests",                    precision: 10, scale: 2, default: 0.0,   null: false
    t.string   "pricing_model",            limit: 255,                                            null: false
    t.string   "custom_domain",            limit: 255
    t.boolean  "custom_domain_force_ssl",  limit: 1
  end

  add_index "competitions", ["country_id"], name: "competitions_country_id_fk", using: :btree
  add_index "competitions", ["default_locale_id"], name: "index_competitions_on_default_locale_id", unique: true, using: :btree
  add_index "competitions", ["delegate_user_id"], name: "competitions_delegate_user_id_fk", using: :btree
  add_index "competitions", ["handle"], name: "index_competitions_on_handle", unique: true, using: :btree
  add_index "competitions", ["name"], name: "index_competitions_on_name", unique: true, using: :btree
  add_index "competitions", ["owner_user_id"], name: "competitions_owner_user_id_fk", using: :btree

  create_table "competitors", force: :cascade do |t|
    t.integer  "competition_id",          limit: 4,                     null: false
    t.string   "first_name",              limit: 255,                   null: false
    t.string   "last_name",               limit: 255,                   null: false
    t.string   "wca",                     limit: 255
    t.string   "email",                   limit: 255,                   null: false
    t.date     "birthday"
    t.integer  "country_id",              limit: 4,                     null: false
    t.boolean  "local",                   limit: 1,     default: false
    t.boolean  "staff",                   limit: 1,     default: false
    t.text     "user_comment",            limit: 65535
    t.text     "admin_comment",           limit: 65535
    t.boolean  "free_entrance",           limit: 1,     default: false
    t.text     "free_entrance_reason",    limit: 65535
    t.string   "state",                   limit: 255
    t.boolean  "confirmation_email_sent", limit: 1,     default: false
    t.boolean  "paid",                    limit: 1,     default: false
    t.text     "paid_comment",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "male",                    limit: 1
    t.text     "nametag",                 limit: 65535
  end

  add_index "competitors", ["competition_id"], name: "index_competitors_on_competition_id", using: :btree
  add_index "competitors", ["country_id"], name: "competitors_country_id_fk", using: :btree
  add_index "competitors", ["wca", "competition_id"], name: "index_competitors_on_wca_and_competition_id", unique: true, using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "index_countries_on_name", unique: true, using: :btree

  create_table "day_registrations", force: :cascade do |t|
    t.integer  "competition_id", limit: 4, null: false
    t.integer  "competitor_id",  limit: 4, null: false
    t.integer  "day_id",         limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "day_registrations", ["competition_id"], name: "day_registrations_competition_id_fk", using: :btree
  add_index "day_registrations", ["competitor_id", "day_id"], name: "index_day_registrations_on_competitor_id_and_day_id", unique: true, using: :btree
  add_index "day_registrations", ["day_id"], name: "day_registrations_day_id_fk", using: :btree

  create_table "days", force: :cascade do |t|
    t.integer  "competition_id",           limit: 4,                          null: false
    t.date     "date",                                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "entrance_fee_competitors",           precision: 10, scale: 2, null: false
    t.decimal  "entrance_fee_guests",                precision: 10, scale: 2, null: false
  end

  add_index "days", ["competition_id"], name: "index_days_on_competition_id", using: :btree
  add_index "days", ["date", "competition_id"], name: "index_days_on_date_and_competition_id", unique: true, using: :btree

  create_table "email_templates", force: :cascade do |t|
    t.integer  "competition_id", limit: 4,     null: false
    t.string   "name",           limit: 255,   null: false
    t.text     "content",        limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject",        limit: 255
  end

  add_index "email_templates", ["competition_id", "name"], name: "index_email_templates_on_competition_id_and_name", unique: true, using: :btree

  create_table "event_registrations", force: :cascade do |t|
    t.integer  "competition_id", limit: 4,                 null: false
    t.integer  "event_id",       limit: 4,                 null: false
    t.integer  "competitor_id",  limit: 4,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "waiting",        limit: 1, default: false, null: false
  end

  add_index "event_registrations", ["competition_id"], name: "index_event_registrations_on_competition_id", using: :btree
  add_index "event_registrations", ["competitor_id", "event_id"], name: "index_event_registrations_on_competitor_id_and_event_id", unique: true, using: :btree
  add_index "event_registrations", ["event_id"], name: "event_registrations_event_id_fk", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "competition_id",              limit: 4,   null: false
    t.integer  "day_id",                      limit: 4,   null: false
    t.string   "name",                        limit: 255, null: false
    t.string   "handle",                      limit: 255
    t.string   "state",                       limit: 255, null: false
    t.integer  "max_number_of_registrations", limit: 4
    t.time     "start_time",                              null: false
    t.integer  "length_in_minutes",           limit: 4
    t.string   "timelimit",                   limit: 255
    t.string   "format",                      limit: 255
    t.string   "round",                       limit: 255
    t.string   "proceed",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["competition_id"], name: "index_events_on_competition_id", using: :btree
  add_index "events", ["day_id"], name: "events_day_id_fk", using: :btree

  create_table "locales", force: :cascade do |t|
    t.string   "handle",         limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "competition_id", limit: 4,   null: false
  end

  add_index "locales", ["competition_id"], name: "index_locales_on_competition_id", using: :btree
  add_index "locales", ["handle", "competition_id"], name: "index_locales_on_handle_and_competition_id", unique: true, using: :btree

  create_table "news", force: :cascade do |t|
    t.integer  "competition_id", limit: 4,     null: false
    t.datetime "time",                         null: false
    t.text     "text",           limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id",      limit: 4,     null: false
  end

  add_index "news", ["competition_id"], name: "index_news_on_competition_id", using: :btree
  add_index "news", ["locale_id"], name: "news_locale_id_fk", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.integer  "competition_id", limit: 4, null: false
    t.integer  "user_id",        limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["competition_id", "user_id"], name: "index_permissions_on_competition_id_and_user_id", using: :btree
  add_index "permissions", ["user_id", "competition_id"], name: "index_permissions_on_user_id_and_competition_id", unique: true, using: :btree

  create_table "theme_files", force: :cascade do |t|
    t.integer  "competition_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content",            limit: 65535
    t.string   "filename",           limit: 255,   null: false
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "theme_id",           limit: 4
  end

  add_index "theme_files", ["competition_id"], name: "theme_files_competition_id_fk", using: :btree
  add_index "theme_files", ["filename", "competition_id"], name: "index_theme_files_on_filename_and_competition_id", unique: true, using: :btree
  add_index "theme_files", ["theme_id", "filename"], name: "index_theme_files_on_theme_id_and_filename", unique: true, using: :btree

  create_table "themes", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "themes", ["name"], name: "index_themes_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",  limit: 255
    t.string   "first_name",       limit: 255,                   null: false
    t.string   "last_name",        limit: 255,                   null: false
    t.boolean  "delegate",         limit: 1,     default: false
    t.integer  "permission_level", limit: 4,                     null: false
    t.text     "address",          limit: 65535
    t.integer  "version",          limit: 4,     default: 0,     null: false
    t.boolean  "active",           limit: 1,     default: true,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "competitions", "countries", name: "competitions_country_id_fk"
  add_foreign_key "competitions", "locales", column: "default_locale_id", name: "competitions_default_locale_id_fk"
  add_foreign_key "competitions", "users", column: "delegate_user_id", name: "competitions_delegate_user_id_fk"
  add_foreign_key "competitions", "users", column: "owner_user_id", name: "competitions_owner_user_id_fk"
  add_foreign_key "competitors", "competitions", name: "competitors_competition_id_fk"
  add_foreign_key "competitors", "countries", name: "competitors_country_id_fk"
  add_foreign_key "day_registrations", "competitions", name: "day_registrations_competition_id_fk"
  add_foreign_key "day_registrations", "competitors", name: "day_registrations_competitor_id_fk"
  add_foreign_key "day_registrations", "days", name: "day_registrations_day_id_fk"
  add_foreign_key "days", "competitions", name: "days_competition_id_fk"
  add_foreign_key "email_templates", "competitions", name: "email_templates_competition_id_fk"
  add_foreign_key "event_registrations", "competitions", name: "event_registrations_competition_id_fk"
  add_foreign_key "event_registrations", "competitors", name: "event_registrations_competitor_id_fk"
  add_foreign_key "event_registrations", "events", name: "event_registrations_event_id_fk"
  add_foreign_key "events", "competitions", name: "events_competition_id_fk"
  add_foreign_key "events", "days", name: "events_day_id_fk"
  add_foreign_key "locales", "competitions", name: "locales_competition_id_fk"
  add_foreign_key "news", "competitions", name: "news_competition_id_fk"
  add_foreign_key "news", "locales", name: "news_locale_id_fk"
  add_foreign_key "permissions", "competitions", name: "permissions_competition_id_fk"
  add_foreign_key "permissions", "users", name: "permissions_user_id_fk"
  add_foreign_key "theme_files", "competitions", name: "theme_files_competition_id_fk"
  add_foreign_key "theme_files", "themes", name: "theme_files_theme_id_fk"
end
