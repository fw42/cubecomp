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

ActiveRecord::Schema.define(version: 20140901230347) do

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
  end

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

  create_table "event_registrations", force: true do |t|
    t.integer  "competition_id"
    t.integer  "event_id"
    t.integer  "competitor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "competition_id"
    t.integer  "day_id"
    t.string   "name_short"
    t.string   "name_long"
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

  create_table "news", force: true do |t|
    t.integer  "competition_id"
    t.datetime "time"
    t.string   "locale"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.integer  "competition_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_admin"
    t.string   "password_digest"
  end

end
