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

ActiveRecord::Schema.define(version: 20140906184425) do

  create_table "competitions", force: true do |t|
    t.string   "name"
    t.string   "handle"
    t.string   "staff_email"
    t.string   "staff_name"
    t.string   "city_name"
    t.string   "city_name_short"
    t.string   "venue_address"
    t.integer  "country_id"
    t.boolean  "cc_orga",           default: false
    t.boolean  "registration_open", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delegate_user_id"
  end

  add_index "competitions", ["handle"], name: "index_competitions_on_handle"

  create_table "competitors", force: true do |t|
    t.integer  "competition_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "wca"
    t.string   "email"
    t.date     "birthday"
    t.integer  "country_id"
    t.boolean  "local"
    t.boolean  "staff"
    t.text     "user_comment"
    t.text     "admin_comment"
    t.boolean  "free_entrance"
    t.string   "free_entrance_reason"
    t.string   "state"
    t.boolean  "confirmation_email_sent"
    t.boolean  "paid"
    t.string   "paid_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competitors", ["competition_id"], name: "index_competitors_on_competition_id"

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days", force: true do |t|
    t.integer  "competition_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "days", ["competition_id"], name: "index_days_on_competition_id"

  create_table "event_registrations", force: true do |t|
    t.integer  "competition_id"
    t.integer  "event_id"
    t.integer  "competitor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_registrations", ["competition_id"], name: "index_event_registrations_on_competition_id"

  create_table "events", force: true do |t|
    t.integer  "competition_id"
    t.integer  "day_id"
    t.string   "name_short"
    t.string   "name"
    t.string   "handle"
    t.string   "state"
    t.integer  "max_number_of_registrations"
    t.time     "start_time"
    t.integer  "length_in_minutes"
    t.string   "timelimit"
    t.string   "format"
    t.string   "round"
    t.string   "proceed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["competition_id"], name: "index_events_on_competition_id"

  create_table "news", force: true do |t|
    t.integer  "competition_id"
    t.datetime "time"
    t.string   "locale"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["competition_id"], name: "index_news_on_competition_id"

  create_table "page_template_bodies", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "competition_id"
    t.string   "handle"
    t.integer  "page_template_body_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["handle"], name: "index_pages_on_handle"

  create_table "permissions", force: true do |t|
    t.integer  "competition_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["competition_id", "user_id"], name: "index_permissions_on_competition_id_and_user_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_admin"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email"

end
