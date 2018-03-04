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

ActiveRecord::Schema.define(version: 20180304135200) do

  create_table "competitions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", null: false
    t.string "handle", null: false
    t.string "staff_email", null: false
    t.string "staff_name"
    t.string "city_name", null: false
    t.string "city_name_short"
    t.text "venue_address"
    t.integer "country_id", null: false
    t.boolean "cc_staff", default: false
    t.boolean "registration_open", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "delegate_user_id"
    t.integer "owner_user_id"
    t.integer "default_locale_id"
    t.string "currency"
    t.boolean "published", default: false
    t.decimal "entrance_fee_competitors", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "entrance_fee_guests", precision: 10, scale: 2, default: "0.0", null: false
    t.string "pricing_model", null: false
    t.string "custom_domain"
    t.boolean "custom_domain_force_ssl", default: false
    t.index ["country_id"], name: "competitions_country_id_fk"
    t.index ["default_locale_id"], name: "index_competitions_on_default_locale_id", unique: true
    t.index ["delegate_user_id"], name: "competitions_delegate_user_id_fk"
    t.index ["handle"], name: "index_competitions_on_handle", unique: true
    t.index ["name"], name: "index_competitions_on_name", unique: true
    t.index ["owner_user_id"], name: "competitions_owner_user_id_fk"
  end

  create_table "competitors", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "wca"
    t.string "email", null: false
    t.date "birthday"
    t.integer "country_id", null: false
    t.boolean "local", default: false
    t.boolean "staff", default: false
    t.text "user_comment"
    t.text "admin_comment"
    t.boolean "free_entrance", default: false
    t.text "free_entrance_reason"
    t.string "state"
    t.boolean "confirmation_email_sent", default: false
    t.boolean "paid", default: false
    t.text "paid_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "nametag"
    t.string "remote_ip"
    t.string "gender", null: false
    t.index ["competition_id"], name: "index_competitors_on_competition_id"
    t.index ["country_id"], name: "competitors_country_id_fk"
    t.index ["remote_ip", "competition_id"], name: "index_competitors_on_remote_ip_and_competition_id"
    t.index ["wca", "competition_id"], name: "index_competitors_on_wca_and_competition_id", unique: true
  end

  create_table "countries", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "day_registrations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.integer "competitor_id", null: false
    t.integer "day_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["competition_id"], name: "day_registrations_competition_id_fk"
    t.index ["competitor_id", "day_id"], name: "index_day_registrations_on_competitor_id_and_day_id", unique: true
    t.index ["day_id"], name: "day_registrations_day_id_fk"
  end

  create_table "days", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.date "date", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "entrance_fee_competitors", precision: 10, scale: 2, null: false
    t.decimal "entrance_fee_guests", precision: 10, scale: 2, null: false
    t.index ["competition_id"], name: "index_days_on_competition_id"
    t.index ["date", "competition_id"], name: "index_days_on_date_and_competition_id", unique: true
  end

  create_table "email_templates", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.string "name", null: false
    t.text "content", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "subject"
    t.index ["competition_id", "name"], name: "index_email_templates_on_competition_id_and_name", unique: true
  end

  create_table "event_registrations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.integer "event_id", null: false
    t.integer "competitor_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "waiting", default: false, null: false
    t.index ["competition_id"], name: "index_event_registrations_on_competition_id"
    t.index ["competitor_id", "event_id"], name: "index_event_registrations_on_competitor_id_and_event_id", unique: true
    t.index ["event_id"], name: "event_registrations_event_id_fk"
  end

  create_table "events", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.integer "day_id", null: false
    t.string "name", null: false
    t.string "handle"
    t.string "state", null: false
    t.integer "max_number_of_registrations"
    t.time "start_time", null: false
    t.integer "length_in_minutes"
    t.string "timelimit"
    t.string "format"
    t.string "round"
    t.string "proceed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["competition_id"], name: "index_events_on_competition_id"
    t.index ["day_id"], name: "events_day_id_fk"
  end

  create_table "locales", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "handle", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "competition_id", null: false
    t.index ["competition_id"], name: "index_locales_on_competition_id"
    t.index ["handle", "competition_id"], name: "index_locales_on_handle_and_competition_id", unique: true
  end

  create_table "news", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.datetime "time", null: false
    t.text "text", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "locale_id", null: false
    t.index ["competition_id"], name: "index_news_on_competition_id"
    t.index ["locale_id"], name: "news_locale_id_fk"
  end

  create_table "permissions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["competition_id", "user_id"], name: "index_permissions_on_competition_id_and_user_id"
    t.index ["user_id", "competition_id"], name: "index_permissions_on_user_id_and_competition_id", unique: true
  end

  create_table "theme_files", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "competition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "content"
    t.string "filename", null: false
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "theme_id"
    t.index ["competition_id"], name: "theme_files_competition_id_fk"
    t.index ["filename", "competition_id"], name: "index_theme_files_on_filename_and_competition_id", unique: true
    t.index ["theme_id", "filename"], name: "index_theme_files_on_theme_id_and_filename", unique: true
  end

  create_table "themes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_themes_on_name", unique: true
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.boolean "delegate", default: false
    t.integer "permission_level", null: false
    t.text "address"
    t.integer "version", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.string "wca"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

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
