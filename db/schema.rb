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

ActiveRecord::Schema.define(version: 20160105092452) do

  create_table "concert_images", force: :cascade do |t|
    t.integer  "concert_id"
    t.binary   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concert_images", ["concert_id"], name: "index_concert_images_on_concert_id"

  create_table "concerts", force: :cascade do |t|
    t.text     "title",      null: false
    t.text     "artist",     null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concerts", ["user_id"], name: "index_concerts_on_user_id"

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.text     "subject",    null: false
    t.text     "request",    null: false
    t.text     "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "events", force: :cascade do |t|
    t.integer  "concert_id", null: false
    t.text     "place",      null: false
    t.datetime "date",       null: false
    t.datetime "sell_start", null: false
    t.datetime "sell_end"
    t.boolean  "lottery",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "events", ["concert_id"], name: "index_events_on_concert_id"

  create_table "grades", force: :cascade do |t|
    t.integer  "event_id",   null: false
    t.text     "name",       null: false
    t.integer  "price",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "grades", ["event_id"], name: "index_grades_on_event_id"

  create_table "lottery_pendings", force: :cascade do |t|
    t.integer  "reservation_id"
    t.integer  "grade_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "lottery_pendings", ["grade_id"], name: "index_lottery_pendings_on_grade_id"
  add_index "lottery_pendings", ["reservation_id"], name: "index_lottery_pendings_on_reservation_id"

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "payment_method",       null: false
    t.text     "convenience_password"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id"

  create_table "tickets", force: :cascade do |t|
    t.integer  "grade_id",       null: false
    t.integer  "reservation_id"
    t.text     "seat",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tickets", ["grade_id", "seat"], name: "index_tickets_on_grade_id_and_seat", unique: true
  add_index "tickets", ["grade_id"], name: "index_tickets_on_grade_id"
  add_index "tickets", ["reservation_id"], name: "index_tickets_on_reservation_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                   default: "", null: false
    t.integer  "role",                   default: 0,  null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
