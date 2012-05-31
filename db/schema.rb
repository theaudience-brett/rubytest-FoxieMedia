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
# PLEASE WORK

ActiveRecord::Schema.define(:version => 20120421181731) do

  create_table "app_configs", :force => true do |t|
    t.string   "confkey"
    t.string   "confval"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "section"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "episodes", :force => true do |t|
    t.integer  "show_id"
    t.integer  "tvdb_id"
    t.integer  "season_no"
    t.integer  "episode_no"
    t.string   "episode_name"
    t.date     "first_aired"
    t.text     "overview"
    t.integer  "last_update"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "episodes", ["show_id"], :name => "index_episodes_on_show_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "show_artworks", :force => true do |t|
    t.integer  "show_id"
    t.integer  "tvdb_id"
    t.string   "path"
    t.string   "basetype"
    t.string   "subtype"
    t.string   "language"
    t.decimal  "rating",     :precision => 10, :scale => 0
    t.string   "thumbnail"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "process",                                   :default => 0
  end

  create_table "shows", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "tvdb_id"
    t.string   "air_day"
    t.string   "air_time"
    t.date     "first_aired"
    t.string   "network"
    t.string   "rating"
    t.string   "status"
    t.integer  "show_artwork_id"
    t.boolean  "public",          :default => false
  end

  create_table "shows_users", :force => true do |t|
    t.integer  "show_id"
    t.integer  "user_id"
    t.integer  "show_artwork_id"
    t.string   "location"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "realname"
    t.boolean  "is_admin",   :default => false
    t.datetime "last_login"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "email"
    t.string   "salt"
  end

  create_table "users_app_configs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "app_config_id"
    t.string   "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users_app_configs", ["app_config_id"], :name => "test"

end
