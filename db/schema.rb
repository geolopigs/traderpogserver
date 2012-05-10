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

ActiveRecord::Schema.define(:version => 20120505163910) do

  create_table "item_infos", :force => true do |t|
    t.integer  "price"
    t.integer  "supplymax_1"
    t.integer  "supplyrate_1"
    t.integer  "supplymax_2"
    t.integer  "supplyrate_2"
    t.integer  "supplymax_3"
    t.integer  "supplyrate_3"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "item_locs", :force => true do |t|
    t.string   "locale"
    t.string   "localized_name"
    t.string   "localized_desc"
    t.integer  "item_info_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "item_locs", ["item_info_id"], :name => "index_item_locs_on_item_info_id"

  create_table "post_items", :force => true do |t|
    t.integer  "post_id"
    t.integer  "item_info_id"
    t.integer  "level"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "post_items", ["item_info_id"], :name => "index_post_items_on_item_info_id"
  add_index "post_items", ["post_id"], :name => "index_post_items_on_post_id"

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.integer  "userid"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "img"
    t.integer  "region"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
