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

ActiveRecord::Schema.define(:version => 20130305070126) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "client_id"
    t.boolean  "super_admin",            :default => false, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "clients", :force => true do |t|
    t.string   "name",        :limit => 35,                  :null => false
    t.string   "short_name",  :limit => 10,                  :null => false
    t.float    "service_pct",               :default => 5.0, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "clients", ["name"], :name => "index_clients_on_name", :unique => true
  add_index "clients", ["short_name"], :name => "index_clients_on_short_name", :unique => true

  create_table "fake_payout_vehicles", :force => true do |t|
    t.string   "code",       :limit => 32, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "monthly_client_data", :force => true do |t|
    t.integer  "client_id",                                       :null => false
    t.integer  "month",                                           :null => false
    t.integer  "year",                                            :null => false
    t.datetime "last_calculated_at"
    t.integer  "beginning_balance",                               :null => false
    t.integer  "ending_balance",                   :default => 0, :null => false
    t.integer  "total_tips_count",                 :default => 0, :null => false
    t.integer  "total_tips_cents",                 :default => 0, :null => false
    t.integer  "total_tips_processing_fees_cents", :default => 0, :null => false
    t.integer  "total_tips_service_cents",         :default => 0, :null => false
    t.integer  "total_tips_client_cents",          :default => 0, :null => false
    t.integer  "total_payouts_count",              :default => 0, :null => false
    t.integer  "total_payouts_cents",              :default => 0, :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "monthly_client_data", ["client_id"], :name => "index_monthly_client_data_on_client_id"

  create_table "payouts", :force => true do |t|
    t.integer  "client_id",                  :null => false
    t.integer  "cents",                      :null => false
    t.string   "vehicle_type", :limit => 25, :null => false
    t.integer  "vehicle_id",                 :null => false
    t.string   "status",       :limit => 20, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "payouts", ["client_id"], :name => "index_payouts_on_client_id"
  add_index "payouts", ["vehicle_id", "vehicle_type"], :name => "index_payouts_on_vehicle_id_and_vehicle_type"

  create_table "stripe_cards", :force => true do |t|
    t.integer  "tipper_id"
    t.string   "stripe_id",           :limit => 36
    t.string   "last4",               :limit => 4,                           :null => false
    t.string   "cc_type",             :limit => 16,                          :null => false
    t.integer  "exp_month",                                                  :null => false
    t.integer  "exp_year",                                                   :null => false
    t.string   "fingerprint",         :limit => 36,                          :null => false
    t.string   "country",                                                    :null => false
    t.string   "name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_city"
    t.string   "address_zip"
    t.string   "address_country"
    t.string   "cvc_check",           :limit => 15, :default => "unchecked", :null => false
    t.string   "address_line1_check", :limit => 15, :default => "unchecked", :null => false
    t.string   "address_zip_check",   :limit => 15, :default => "unchecked", :null => false
    t.boolean  "fake",                              :default => false,       :null => false
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "tippers", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "tippers", ["email"], :name => "index_tippers_on_email", :unique => true
  add_index "tippers", ["reset_password_token"], :name => "index_tippers_on_reset_password_token", :unique => true

  create_table "tips", :force => true do |t|
    t.integer  "client_id",                                              :null => false
    t.integer  "tipper_id"
    t.integer  "payment_method_id",                                      :null => false
    t.string   "payment_method_type",                                    :null => false
    t.integer  "total_cents",                                            :null => false
    t.integer  "processing_fees_cents",                                  :null => false
    t.integer  "service_cents",                                          :null => false
    t.integer  "client_cents",                                           :null => false
    t.string   "status",                :limit => 20,                    :null => false
    t.boolean  "fake",                                :default => false, :null => false
    t.boolean  "paid",                                :default => true,  :null => false
    t.integer  "refunded_cents",                      :default => 0,     :null => false
    t.boolean  "disputed",                            :default => false, :null => false
    t.string   "third_party_id",                                         :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
  end

  add_index "tips", ["client_id"], :name => "index_tips_on_client_id"
  add_index "tips", ["payment_method_type", "payment_method_id"], :name => "index_tips_on_payment_method_type_and_payment_method_id"

end
