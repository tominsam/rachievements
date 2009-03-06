# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090306152245) do

  create_table "achievement_toons", :force => true do |t|
    t.integer  "toon_id"
    t.integer  "achievement_id"
    t.datetime "recorded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "achievements", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "armory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guilds", :force => true do |t|
    t.string   "name",       :limit => 64
    t.string   "urltoken"
    t.integer  "realm_id"
    t.datetime "fetched_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "realms", :force => true do |t|
    t.string   "name",       :limit => 64
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "toons", :force => true do |t|
    t.string   "name"
    t.integer  "realm_id"
    t.integer  "guild_id"
    t.integer  "rank"
    t.integer  "achpoints"
    t.string   "race",       :limit => 16
    t.string   "classname",  :limit => 16
    t.string   "gender",     :limit => 16
    t.integer  "level"
    t.datetime "fetched_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "md5password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
