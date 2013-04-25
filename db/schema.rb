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

ActiveRecord::Schema.define(:version => 20130418120823) do

  create_table "attendance_figures", :primary_key => "attendance_figure_id", :force => true do |t|
    t.integer  "attendance_figure"
    t.datetime "attendance_figure_day"
    t.string   "location_created"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "catchment_areas", :primary_key => "catchment_area_id", :force => true do |t|
    t.integer  "population_size"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "global_properties", :primary_key => "property_id", :force => true do |t|
    t.string   "property"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "health_care_indicators", :primary_key => "indicator_id", :force => true do |t|
    t.string   "indicator_type"
    t.integer  "location_id"
    t.integer  "indicator_value"
    t.date     "indicator_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_tag_maps", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "location_tag_id"
  end

  create_table "location_tags", :primary_key => "location_tag_id", :force => true do |t|
    t.string   "location_tag_name"
    t.integer  "creator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :primary_key => "location_id", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "creator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :primary_key => "msg_id", :force => true do |t|
    t.string   "msg_type",       :limit => 0
    t.string   "msg_group",      :limit => 0
    t.string   "content_type",   :limit => 0
    t.string   "heading"
    t.text     "msg_text"
    t.decimal  "duration",                    :precision => 64, :scale => 2
    t.integer  "media_width"
    t.integer  "media_height"
    t.string   "content_path"
    t.text     "media_bg_color"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "creator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :primary_key => "service_id", :force => true do |t|
    t.string   "service_name"
    t.integer  "location_offered"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :primary_key => "user_id", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "username"
    t.string   "user_role"
    t.integer  "creator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
