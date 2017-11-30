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

ActiveRecord::Schema.define(version: 20171130185139) do

  create_table "event_descriptions", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "language", null: false
    t.string "content", null: false
    t.index ["event_id", "language"], name: "index_event_descriptions_on_event_id_and_language", unique: true
    t.index ["event_id"], name: "index_event_descriptions_on_event_id"
  end

  create_table "event_tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon_url", null: false
    t.string "color", null: false
    t.index ["name"], name: "index_event_tags_on_name", unique: true
  end

  create_table "event_tags_events", id: false, force: :cascade do |t|
    t.integer "event_tag_id", null: false
    t.integer "event_id", null: false
    t.index ["event_id", "event_tag_id"], name: "index_event_tags_events_on_event_id_and_event_tag_id", unique: true
    t.index ["event_tag_id", "event_id"], name: "index_event_tags_events_on_event_tag_id_and_event_id", unique: true
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon_url", null: false
    t.index ["name"], name: "index_event_types_on_name", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "org_id"
    t.string "name", null: false
    t.string "image_url"
    t.decimal "lat"
    t.decimal "lon"
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.datetime "created_at", default: "2017-11-30 19:14:58", null: false
    t.datetime "updated_at", default: "2017-11-30 19:14:58", null: false
    t.integer "event_type_id"
    t.string "fb_url"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["lat"], name: "index_events_on_lat"
    t.index ["lon"], name: "index_events_on_lon"
    t.index ["name"], name: "index_events_on_name"
    t.index ["org_id"], name: "index_events_on_org_id"
    t.index ["start_time"], name: "index_events_on_start_time"
  end

  create_table "link_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon_url", null: false
    t.index ["name"], name: "index_link_types_on_name", unique: true
  end

  create_table "org_administrations", id: false, force: :cascade do |t|
    t.string "org_id", null: false
    t.string "user_id", null: false
    t.index ["org_id", "user_id"], name: "index_org_administrations_on_org_id_and_user_id", unique: true
    t.index ["user_id", "org_id"], name: "index_org_administrations_on_user_id_and_org_id", unique: true
  end

  create_table "org_descriptions", force: :cascade do |t|
    t.string "org_id", null: false
    t.string "language", null: false
    t.string "content", null: false
    t.index ["org_id", "language"], name: "index_org_descriptions_on_org_id_and_language", unique: true
    t.index ["org_id"], name: "index_org_descriptions_on_org_id"
  end

  create_table "org_links", id: false, force: :cascade do |t|
    t.string "org_id", null: false
    t.integer "link_type_id", null: false
    t.string "url", null: false
    t.index ["org_id", "link_type_id"], name: "index_org_links_on_org_id_and_link_type_id", unique: true
  end

  create_table "org_tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon_url", null: false
    t.string "color", null: false
    t.index ["name"], name: "index_org_tags_on_name", unique: true
  end

  create_table "org_tags_orgs", id: false, force: :cascade do |t|
    t.integer "org_tag_id", null: false
    t.string "org_id", null: false
    t.index ["org_id", "org_tag_id"], name: "index_org_tags_orgs_on_org_id_and_org_tag_id", unique: true
    t.index ["org_tag_id", "org_id"], name: "index_org_tags_orgs_on_org_tag_id_and_org_id", unique: true
  end

  create_table "org_types", force: :cascade do |t|
    t.string "name"
    t.string "icon_url"
  end

  create_table "orgs", id: :string, force: :cascade do |t|
    t.string "display_id", null: false
    t.integer "org_type_id", null: false
    t.string "name", null: false
    t.string "logo_url", null: false
    t.string "cover_url", null: false
    t.string "video_url"
    t.string "marker_url", null: false
    t.string "marker_color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "sqlite_autoindex_orgs_1", unique: true
    t.index ["name"], name: "index_orgs_on_name", unique: true
    t.index ["org_type_id"], name: "index_orgs_on_org_type_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "display_id", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "activation_digest"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id"], name: "sqlite_autoindex_users_1", unique: true
  end

end
