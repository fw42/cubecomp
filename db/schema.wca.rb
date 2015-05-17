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

  create_table "Competitions", id: false, force: :cascade do |t|
    t.string  "id",           limit: 32,       default: "", null: false
    t.string  "name",         limit: 50,       default: "", null: false
    t.string  "cityName",     limit: 50,       default: "", null: false
    t.string  "countryId",    limit: 50,       default: "", null: false
    t.text    "information",  limit: 16777215
    t.integer "year",         limit: 2,        default: 0,  null: false
    t.integer "month",        limit: 2,        default: 0,  null: false
    t.integer "day",          limit: 2,        default: 0,  null: false
    t.integer "endMonth",     limit: 2,        default: 0,  null: false
    t.integer "endDay",       limit: 2,        default: 0,  null: false
    t.text    "eventSpecs",   limit: 65535,                 null: false
    t.string  "wcaDelegate",  limit: 240,      default: "", null: false
    t.string  "organiser",    limit: 200,      default: "", null: false
    t.string  "venue",        limit: 240,      default: "", null: false
    t.string  "venueAddress", limit: 120
    t.string  "venueDetails", limit: 120
    t.string  "website",      limit: 200
    t.string  "cellName",     limit: 45,       default: "", null: false
    t.integer "latitude",     limit: 4,        default: 0,  null: false
    t.integer "longitude",    limit: 4,        default: 0,  null: false
  end

  create_table "Continents", id: false, force: :cascade do |t|
    t.string  "id",         limit: 50, default: "", null: false
    t.string  "name",       limit: 50, default: "", null: false
    t.string  "recordName", limit: 3,  default: "", null: false
    t.integer "latitude",   limit: 4,  default: 0,  null: false
    t.integer "longitude",  limit: 4,  default: 0,  null: false
    t.integer "zoom",       limit: 1,  default: 0,  null: false
  end

  create_table "Countries", id: false, force: :cascade do |t|
    t.string  "id",          limit: 50, default: "", null: false
    t.string  "name",        limit: 50, default: "", null: false
    t.string  "continentId", limit: 50, default: "", null: false
    t.integer "latitude",    limit: 4,  default: 0,  null: false
    t.integer "longitude",   limit: 4,  default: 0,  null: false
    t.integer "zoom",        limit: 1,  default: 0,  null: false
    t.string  "iso2",        limit: 2
  end

  create_table "Events", id: false, force: :cascade do |t|
    t.string  "id",       limit: 6,  default: "", null: false
    t.string  "name",     limit: 54, default: "", null: false
    t.integer "rank",     limit: 4,  default: 0,  null: false
    t.string  "format",   limit: 10, default: "", null: false
    t.string  "cellName", limit: 45, default: "", null: false
  end

  create_table "Formats", id: false, force: :cascade do |t|
    t.string "id",   limit: 1,  default: "", null: false
    t.string "name", limit: 50, default: "", null: false
  end

  create_table "Persons", id: false, force: :cascade do |t|
    t.string  "id",        limit: 10, default: "", null: false
    t.integer "subid",     limit: 1,  default: 1,  null: false
    t.string  "name",      limit: 80
    t.string  "countryId", limit: 50, default: "", null: false
    t.string  "gender",    limit: 1,  default: "", null: false
  end

  add_index "Persons", ["id"], name: "persons_person_id", using: :btree

  create_table "RanksAverage", id: false, force: :cascade do |t|
    t.string  "personId",      limit: 10, default: "", null: false
    t.string  "eventId",       limit: 6,  default: "", null: false
    t.integer "best",          limit: 4,  default: 0,  null: false
    t.integer "worldRank",     limit: 4,  default: 0,  null: false
    t.integer "continentRank", limit: 4,  default: 0,  null: false
    t.integer "countryRank",   limit: 4,  default: 0,  null: false
  end

  create_table "RanksSingle", id: false, force: :cascade do |t|
    t.string  "personId",      limit: 10, default: "", null: false
    t.string  "eventId",       limit: 6,  default: "", null: false
    t.integer "best",          limit: 4,  default: 0,  null: false
    t.integer "worldRank",     limit: 4,  default: 0,  null: false
    t.integer "continentRank", limit: 4,  default: 0,  null: false
    t.integer "countryRank",   limit: 4,  default: 0,  null: false
  end

  create_table "Results", id: false, force: :cascade do |t|
    t.string  "competitionId",         limit: 32, default: "", null: false
    t.string  "eventId",               limit: 6,  default: "", null: false
    t.string  "roundId",               limit: 1,  default: "", null: false
    t.integer "pos",                   limit: 2,  default: 0,  null: false
    t.integer "best",                  limit: 4,  default: 0,  null: false
    t.integer "average",               limit: 4,  default: 0,  null: false
    t.string  "personName",            limit: 80
    t.string  "personId",              limit: 10, default: "", null: false
    t.string  "personCountryId",       limit: 50
    t.string  "formatId",              limit: 1,  default: "", null: false
    t.integer "value1",                limit: 4,  default: 0,  null: false
    t.integer "value2",                limit: 4,  default: 0,  null: false
    t.integer "value3",                limit: 4,  default: 0,  null: false
    t.integer "value4",                limit: 4,  default: 0,  null: false
    t.integer "value5",                limit: 4,  default: 0,  null: false
    t.string  "regionalSingleRecord",  limit: 3
    t.string  "regionalAverageRecord", limit: 3
  end

  add_index "Results", ["average"], name: "results_average", using: :btree
  add_index "Results", ["best"], name: "results_best", using: :btree
  add_index "Results", ["eventId"], name: "results_event_id", using: :btree
  add_index "Results", ["personCountryId"], name: "results_person_country_id", using: :btree
  add_index "Results", ["personId"], name: "results_person_id", using: :btree

  create_table "Rounds", id: false, force: :cascade do |t|
    t.string  "id",       limit: 1,  default: "", null: false
    t.integer "rank",     limit: 4,  default: 0,  null: false
    t.string  "name",     limit: 50, default: "", null: false
    t.string  "cellName", limit: 45, default: "", null: false
  end

  create_table "Scrambles", id: false, force: :cascade do |t|
    t.integer "scrambleId",    limit: 4,   default: 0, null: false
    t.string  "competitionId", limit: 32,              null: false
    t.string  "eventId",       limit: 6,               null: false
    t.string  "roundId",       limit: 1,               null: false
    t.string  "groupId",       limit: 3,               null: false
    t.boolean "isExtra",       limit: 1,               null: false
    t.integer "scrambleNum",   limit: 4,               null: false
    t.string  "scramble",      limit: 500,             null: false
  end

end
