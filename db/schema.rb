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

ActiveRecord::Schema.define(version: 20141018201016) do

  create_table "competitions", force: true do |t|
    t.string   "name",                              null: false
    t.string   "handle",                            null: false
    t.string   "staff_email",                       null: false
    t.string   "staff_name"
    t.string   "city_name",                         null: false
    t.string   "city_name_short"
    t.string   "venue_address"
    t.integer  "country_id",                        null: false
    t.boolean  "cc_orga",           default: false
    t.boolean  "registration_open", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delegate_user_id"
    t.integer  "owner_user_id"
  end

  add_index "competitions", ["country_id"], name: "competitions_country_id_fk", using: :btree
  add_index "competitions", ["delegate_user_id"], name: "competitions_delegate_user_id_fk", using: :btree
  add_index "competitions", ["handle"], name: "index_competitions_on_handle", unique: true, using: :btree
  add_index "competitions", ["name"], name: "index_competitions_on_name", unique: true, using: :btree
  add_index "competitions", ["owner_user_id"], name: "competitions_owner_user_id_fk", using: :btree

  create_table "competitors", force: true do |t|
    t.integer  "competition_id",                          null: false
    t.string   "first_name",                              null: false
    t.string   "last_name",                               null: false
    t.string   "wca"
    t.string   "email",                                   null: false
    t.date     "birthday"
    t.integer  "country_id",                              null: false
    t.boolean  "local",                   default: false
    t.boolean  "staff",                   default: false
    t.text     "user_comment"
    t.text     "admin_comment"
    t.boolean  "free_entrance",           default: false
    t.string   "free_entrance_reason"
    t.string   "state"
    t.boolean  "confirmation_email_sent", default: false
    t.boolean  "paid",                    default: false
    t.string   "paid_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "male"
    t.string   "nametag"
  end

  add_index "competitors", ["competition_id"], name: "index_competitors_on_competition_id", using: :btree
  add_index "competitors", ["country_id"], name: "competitors_country_id_fk", using: :btree
  add_index "competitors", ["wca", "competition_id"], name: "index_competitors_on_wca_and_competition_id", unique: true, using: :btree

  create_table "countries", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "index_countries_on_name", unique: true, using: :btree

  create_table "day_registrations", force: true do |t|
    t.integer  "competition_id", null: false
    t.integer  "competitor_id",  null: false
    t.integer  "day_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "day_registrations", ["competition_id"], name: "day_registrations_competition_id_fk", using: :btree
  add_index "day_registrations", ["competitor_id", "day_id"], name: "index_day_registrations_on_competitor_id_and_day_id", unique: true, using: :btree
  add_index "day_registrations", ["day_id"], name: "day_registrations_day_id_fk", using: :btree

  create_table "days", force: true do |t|
    t.integer  "competition_id",                                    null: false
    t.date     "date",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "entrance_fee_competitors", precision: 10, scale: 2, null: false
    t.decimal  "entrance_fee_guests",      precision: 10, scale: 2, null: false
  end

  add_index "days", ["competition_id"], name: "index_days_on_competition_id", using: :btree
  add_index "days", ["date", "competition_id"], name: "index_days_on_date_and_competition_id", unique: true, using: :btree

  create_table "event_registrations", force: true do |t|
    t.integer  "competition_id",                 null: false
    t.integer  "event_id",                       null: false
    t.integer  "competitor_id",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "waiting",        default: false, null: false
  end

  add_index "event_registrations", ["competition_id"], name: "index_event_registrations_on_competition_id", using: :btree
  add_index "event_registrations", ["competitor_id", "event_id"], name: "index_event_registrations_on_competitor_id_and_event_id", unique: true, using: :btree
  add_index "event_registrations", ["event_id"], name: "event_registrations_event_id_fk", using: :btree

  create_table "events", force: true do |t|
    t.integer  "competition_id",              null: false
    t.integer  "day_id",                      null: false
    t.string   "name_short",                  null: false
    t.string   "name",                        null: false
    t.string   "handle",                      null: false
    t.string   "state",                       null: false
    t.integer  "max_number_of_registrations"
    t.time     "start_time",                  null: false
    t.integer  "length_in_minutes"
    t.string   "timelimit"
    t.string   "format"
    t.string   "round"
    t.string   "proceed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["competition_id"], name: "index_events_on_competition_id", using: :btree
  add_index "events", ["day_id"], name: "events_day_id_fk", using: :btree
  add_index "events", ["handle", "competition_id"], name: "index_events_on_handle_and_competition_id", unique: true, using: :btree

  create_table "locales", force: true do |t|
    t.string   "handle",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "competition_id", null: false
  end

  add_index "locales", ["competition_id"], name: "index_locales_on_competition_id", using: :btree
  add_index "locales", ["handle", "competition_id"], name: "index_locales_on_handle_and_competition_id", unique: true, using: :btree

  create_table "news", force: true do |t|
    t.integer  "competition_id", null: false
    t.datetime "time",           null: false
    t.string   "text",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id",      null: false
  end

  add_index "news", ["competition_id"], name: "index_news_on_competition_id", using: :btree
  add_index "news", ["locale_id"], name: "news_locale_id_fk", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "competition_id", null: false
    t.integer  "user_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["competition_id", "user_id"], name: "index_permissions_on_competition_id_and_user_id", using: :btree
  add_index "permissions", ["user_id", "competition_id"], name: "index_permissions_on_user_id_and_competition_id", unique: true, using: :btree

  create_table "theme_files", force: true do |t|
    t.integer  "competition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.string   "filename",           null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "theme_id"
  end

  add_index "theme_files", ["competition_id"], name: "theme_files_competition_id_fk", using: :btree
  add_index "theme_files", ["filename", "competition_id"], name: "index_theme_files_on_filename_and_competition_id", unique: true, using: :btree

  create_table "themes", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "themes", ["name"], name: "index_themes_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "first_name",                       null: false
    t.string   "last_name",                        null: false
    t.boolean  "delegate",         default: false
    t.integer  "permission_level",                 null: false
    t.text     "address"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "competitions", "countries", name: "competitions_country_id_fk"
  add_foreign_key "competitions", "users", name: "competitions_delegate_user_id_fk", column: "delegate_user_id"
  add_foreign_key "competitions", "users", name: "competitions_owner_user_id_fk", column: "owner_user_id"

  add_foreign_key "competitors", "competitions", name: "competitors_competition_id_fk"
  add_foreign_key "competitors", "countries", name: "competitors_country_id_fk"

  add_foreign_key "day_registrations", "competitions", name: "day_registrations_competition_id_fk"
  add_foreign_key "day_registrations", "competitors", name: "day_registrations_competitor_id_fk"
  add_foreign_key "day_registrations", "days", name: "day_registrations_day_id_fk"

  add_foreign_key "days", "competitions", name: "days_competition_id_fk"

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

end
