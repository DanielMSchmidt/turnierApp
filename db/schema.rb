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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140703105730) do

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "clubs", ["user_id"], :name => "index_clubs_on_user_id"

  create_table "couples", :force => true do |t|
    t.integer  "man_id"
    t.integer  "woman_id"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "couple_id"
    t.integer  "club_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "verified",   :default => true
    t.boolean  "trainer",    :default => false
  end

  add_index "memberships", ["club_id"], :name => "index_memberships_on_club_id"
  add_index "memberships", ["couple_id"], :name => "index_memberships_on_user_id"

  create_table "progresses", :force => true do |t|
    t.integer  "couple_id"
    t.string   "kind"
    t.integer  "start_points"
    t.integer  "start_placings"
    t.string   "start_class"
    t.boolean  "finished"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "tournaments", :force => true do |t|
    t.integer  "number"
    t.integer  "progress_id"
    t.integer  "place"
    t.integer  "participants"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "address"
    t.datetime "date"
    t.string   "kind"
    t.string   "notes"
    t.boolean  "enrolled",          :default => true
    t.date     "notificated_about"
    t.boolean  "fetched",           :default => false
  end

  add_index "tournaments", ["progress_id"], :name => "index_tournaments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
