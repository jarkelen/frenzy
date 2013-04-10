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

ActiveRecord::Schema.define(:version => 20130405131011) do

  create_table "clubs", :force => true do |t|
    t.string   "club_name"
    t.integer  "period1"
    t.integer  "period2"
    t.integer  "period3"
    t.integer  "period4"
    t.integer  "league_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gamerounds", :force => true do |t|
    t.integer  "number"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "processed"
    t.integer  "period_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jokers", :force => true do |t|
    t.integer  "gameround_id"
    t.integer  "user_id"
    t.integer  "club_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "leagues", :force => true do |t|
    t.string   "league_name"
    t.string   "league_short"
    t.integer  "level"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "periods", :force => true do |t|
    t.integer  "period_nr"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "rankings", :force => true do |t|
    t.integer  "total_score"
    t.integer  "gameround_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "results", :force => true do |t|
    t.integer  "home_club_id"
    t.integer  "away_club_id"
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "gameround_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "score"
    t.integer  "gameround_id"
    t.integer  "club_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "selections", :force => true do |t|
    t.integer  "club_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.integer  "current_period"
    t.integer  "max_teamsize"
    t.integer  "max_jokers"
    t.boolean  "participation"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "team_name"
    t.string   "email",                                                 :null => false
    t.string   "language"
    t.string   "role",                              :default => "user"
    t.integer  "team_value",                        :default => 125
    t.integer  "assigned_jokers"
    t.string   "encrypted_password", :limit => 128,                     :null => false
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128,                     :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
