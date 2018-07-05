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

ActiveRecord::Schema.define(version: 20180703151803) do

  create_table "accounts", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                 null: false
    t.string   "user_name",               null: false
    t.string   "img",        default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "event_comments", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "event_id",                 null: false
    t.integer  "user_id",                  null: false
    t.string   "user_name",                null: false
    t.text     "comment",    limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["event_id"], name: "index_event_comments_on_event_id", using: :btree
  end

  create_table "event_participants", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "event_id",   null: false
    t.integer  "user_id",    null: false
    t.string   "user_name",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_participants_on_event_id", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "team_id",                               null: false
    t.integer  "user_id",                               null: false
    t.string   "subject",                  default: "", null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "body",       limit: 65535
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "prefs", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string "pref_name", null: false
  end

  create_table "sports", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_users", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "team_id",              null: false
    t.integer  "user_id",              null: false
    t.integer  "role",       limit: 1, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "teams", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "team_name",                               null: false
    t.integer  "private_flag", limit: 1,                  null: false
    t.integer  "sport_id",                                null: false
    t.integer  "pref_id",                                 null: false
    t.string   "location",                                null: false
    t.string   "img",                        default: "", null: false
    t.text     "body",         limit: 65535,              null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "uid",                               default: "", null: false, collation: "utf8_general_ci"
    t.string   "provider",               limit: 32, default: "", null: false, collation: "utf8_general_ci"
    t.string   "name",                              default: "", null: false, collation: "utf8_general_ci"
    t.string   "profile_img_url",                   default: "", null: false, collation: "utf8_general_ci"
    t.string   "email",                             default: "", null: false, collation: "utf8_general_ci"
    t.string   "endpoint",                          default: "", null: false, collation: "utf8_general_ci"
    t.string   "encrypted_password",                default: "", null: false, collation: "utf8_general_ci"
    t.string   "reset_password_token",                                        collation: "utf8_general_ci"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                                          collation: "utf8_general_ci"
    t.string   "last_sign_in_ip",                                             collation: "utf8_general_ci"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end
