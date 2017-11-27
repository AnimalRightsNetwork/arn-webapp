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

ActiveRecord::Schema.define(version: 20171128001720) do

  create_table "event_descriptions", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "language", null: false
    t.string "content", null: false
    t.index ["event_id", "language"], name: "index_event_descriptions_on_event_id_and_language", unique: true
    t.index ["event_id"], name: "index_event_descriptions_on_event_id"
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon_url", null: false
    t.index ["name"], name: "index_event_types_on_name", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.integer "org_id"
    t.integer "type_id", null: false
    t.string "name", null: false
    t.string "image_url"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lon", precision: 10, scale: 6
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_time"], name: "index_events_on_end_time"
    t.index ["lat"], name: "index_events_on_lat"
    t.index ["lon"], name: "index_events_on_lon"
    t.index ["name"], name: "index_events_on_name"
    t.index ["org_id"], name: "index_events_on_org_id"
    t.index ["start_time"], name: "index_events_on_start_time"
    t.index ["type_id"], name: "index_events_on_type_id"
  end

  create_table "org_types", force: :cascade do |t|
    t.string "name"
    t.string "icon_url"
  end

  create_table "orgs", id: :string, force: :cascade do |t|
    t.string "display_id"
    t.integer "type_id"
    t.string "name"
    t.string "logo_url"
    t.string "cover_url"
    t.string "video_url"
    t.string "marker_url"
    t.string "marker_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "sqlite_autoindex_orgs_1", unique: true
    t.index ["name"], name: "index_orgs_on_name"
    t.index ["type_id"], name: "index_orgs_on_type_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "activation_digest"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id"], name: "sqlite_autoindex_users_1", unique: true
  end

end
