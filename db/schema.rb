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

ActiveRecord::Schema.define(version: 20160605231420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "metric_points", force: :cascade do |t|
    t.integer  "metric_id"
    t.datetime "datetime"
    t.decimal  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "metric_points", ["metric_id", "datetime"], name: "index_metric_points_on_metric_id_and_datetime", using: :btree
  add_index "metric_points", ["metric_id"], name: "index_metric_points_on_metric_id", using: :btree

  create_table "metrics", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "internal_name"
    t.string   "unit"
  end

  add_index "metrics", ["internal_name"], name: "index_metrics_on_internal_name", using: :btree

  add_foreign_key "metric_points", "metrics"
end
