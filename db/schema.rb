# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_02_170945) do

  create_table "merchant_accounts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "merchant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_merchant_accounts_on_merchant_id"
    t.index ["user_id"], name: "index_merchant_accounts_on_user_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "restocking_shipment_items", force: :cascade do |t|
    t.integer "sku_id", null: false
    t.integer "restocking_shipment_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restocking_shipment_id"], name: "index_restocking_shipment_items_on_restocking_shipment_id"
    t.index ["sku_id"], name: "index_restocking_shipment_items_on_sku_id"
  end

  create_table "restocking_shipments", force: :cascade do |t|
    t.integer "shipment_provider_id", null: false
    t.integer "merchant_id", null: false
    t.string "status"
    t.float "shipping_cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tracking_code"
    t.datetime "estimated_arrival_date"
    t.index ["merchant_id"], name: "index_restocking_shipments_on_merchant_id"
    t.index ["shipment_provider_id"], name: "index_restocking_shipments_on_shipment_provider_id"
  end

  create_table "shipment_providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skus", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "merchant_accounts", "merchants"
  add_foreign_key "merchant_accounts", "users"
  add_foreign_key "restocking_shipment_items", "restocking_shipments"
  add_foreign_key "restocking_shipment_items", "skus"
  add_foreign_key "restocking_shipments", "merchants"
  add_foreign_key "restocking_shipments", "shipment_providers"
end
