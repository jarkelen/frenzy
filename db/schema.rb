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

ActiveRecord::Schema.define(:version => 20130603174136) do

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

  add_index "clubs", ["league_id"], :name => "index_clubs_on_league_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "gamerounds", :force => true do |t|
    t.integer  "number"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "processed"
    t.integer  "period_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "gamerounds", ["period_id"], :name => "index_gamerounds_on_period_id"

  create_table "jokers", :force => true do |t|
    t.integer  "gameround_id"
    t.integer  "user_id"
    t.integer  "club_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "jokers", ["club_id"], :name => "index_jokers_on_club_id"
  add_index "jokers", ["gameround_id"], :name => "index_jokers_on_gameround_id"
  add_index "jokers", ["user_id"], :name => "index_jokers_on_user_id"

  create_table "leagues", :force => true do |t|
    t.string   "league_name"
    t.string   "league_short"
    t.integer  "level"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "newsitems", :force => true do |t|
    t.string   "title_nl"
    t.string   "title_en"
    t.text     "summary_nl"
    t.text     "summary_en"
    t.text     "content_nl"
    t.text     "content_en"
    t.boolean  "publish"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "sticky"
    t.string   "priority"
  end

  create_table "periods", :force => true do |t|
    t.integer  "period_nr"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "profiles", :force => true do |t|
    t.string   "location"
    t.string   "website"
    t.string   "bio"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "profile_photo"
    t.string   "favorite_club"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "rankings", :force => true do |t|
    t.integer  "total_score"
    t.integer  "gameround_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "rankings", ["gameround_id"], :name => "index_rankings_on_gameround_id"
  add_index "rankings", ["user_id"], :name => "index_rankings_on_user_id"

  create_table "results", :force => true do |t|
    t.integer  "home_club_id"
    t.integer  "away_club_id"
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "gameround_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "results", ["away_club_id"], :name => "index_results_on_away_club_id"
  add_index "results", ["gameround_id"], :name => "index_results_on_gameround_id"
  add_index "results", ["home_club_id"], :name => "index_results_on_home_club_id"

  create_table "scores", :force => true do |t|
    t.integer  "score"
    t.integer  "gameround_id"
    t.integer  "club_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "scores", ["club_id"], :name => "index_scores_on_club_id"
  add_index "scores", ["gameround_id"], :name => "index_scores_on_gameround_id"

  create_table "selections", :force => true do |t|
    t.integer  "club_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "selections", ["club_id"], :name => "index_selections_on_club_id"
  add_index "selections", ["user_id"], :name => "index_selections_on_user_id"

  create_table "settings", :force => true do |t|
    t.integer  "current_period"
    t.integer  "max_teamsize"
    t.integer  "max_jokers"
    t.boolean  "participation"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "max_teamvalue"
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
    t.datetime "participation_due"
    t.string   "location"
    t.string   "website"
    t.string   "bio"
    t.string   "facebook"
    t.string   "twitter"
    t.integer  "favorite_club"
    t.datetime "birth_date"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
