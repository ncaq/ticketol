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

ActiveRecord::Schema.define(version: 20151203065512) do

  create_table "concerts", force: :cascade do |t|
    t.text     "title"
    t.integer  "artist_id"
    t.binary   "image"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concerts", ["artist_id"], name: "index_concerts_on_artist_id"
  add_index "concerts", ["user_id"], name: "index_concerts_on_user_id"

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "subject"
    t.text     "request"
    t.text     "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id"

  create_table "events", force: :cascade do |t|
    t.integer  "concert_id"
    t.text     "place"
    t.datetime "date"
    t.datetime "sell_start"
    t.datetime "sell_end"
    t.boolean  "lottery"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "events", ["concert_id"], name: "index_events_on_concert_id"

  create_table "grades", force: :cascade do |t|
    t.integer  "event_id"
    t.text     "name"
    t.integer  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "grades", ["event_id"], name: "index_grades_on_event_id"

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "payment_method"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id"

  create_table "tickets", force: :cascade do |t|
    t.integer  "grade_id"
    t.integer  "reservation_id"
    t.text     "seat"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tickets", ["grade_id"], name: "index_tickets_on_grade_id"
  add_index "tickets", ["reservation_id"], name: "index_tickets_on_reservation_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
