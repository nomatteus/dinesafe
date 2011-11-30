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

ActiveRecord::Schema.define(:version => 20111130195323) do

  create_table "inspections", :force => true do |t|
    t.integer  "establishment_id"
    t.integer  "inspection_id"
    t.string   "establishment_name"
    t.string   "establishment_type"
    t.string   "establishment_address"
    t.string   "establishment_status"
    t.integer  "minimum_inspections_per_year"
    t.string   "infraction_details"
    t.date     "inspection_date"
    t.string   "severity"
    t.string   "action"
    t.string   "court_outcome"
    t.float    "amount_fined"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
