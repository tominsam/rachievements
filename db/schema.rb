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

  create_table "achievements", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.integer  "armory_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_achievements", :force => true do |t|
    t.integer  "character_id",   :null => false
    t.integer  "achievement_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.string   "name",       :limit => 64, :null => false
    t.string   "urltoken",   :limit => 64, :null => false
    t.integer  "realm_id",                 :null => false
    t.integer  "guild_id"
    t.integer  "rank",                     :null => false
    t.integer  "achpoints",                :null => false
    t.string   "race",       :limit => 16, :null => false
    t.string   "classname",  :limit => 16, :null => false
    t.string   "gender",     :limit => 16, :null => false
    t.integer  "level",                    :null => false
    t.datetime "fetched_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guilds", :force => true do |t|
    t.string   "name",       :limit => 64
    t.string   "urltoken",   :limit => 64, :null => false
    t.integer  "realm_id",                 :null => false
    t.datetime "fetched_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "realms", :force => true do |t|
    t.string   "name",       :limit => 64, :null => false
    t.string   "urltoken",   :limit => 64, :null => false
    t.string   "region",     :limit => 2,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",       :null => false
    t.string   "md5password"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
