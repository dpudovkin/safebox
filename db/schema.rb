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

ActiveRecord::Schema.define(version: 2021_04_24_085602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "box_types", force: :cascade do |t|
    t.string "name"
    t.float "length"
    t.float "width"
    t.float "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "boxes", force: :cascade do |t|
    t.integer "number"
    t.bigint "box_type_id"
    t.bigint "section_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["box_type_id"], name: "index_boxes_on_box_type_id"
    t.index ["section_id"], name: "index_boxes_on_section_id"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "passport_id"
    t.string "phone_number", limit: 12
    t.string "extra_phone_number", limit: 12
    t.string "email", limit: 50
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["passport_id"], name: "index_clients_on_passport_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "previous_contract_id"
    t.bigint "terminations_of_contract_id"
    t.bigint "box_id"
    t.float "deposit_amount"
    t.integer "rental_days"
    t.date "start_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["box_id"], name: "index_contracts_on_box_id"
    t.index ["client_id"], name: "index_contracts_on_client_id"
    t.index ["previous_contract_id"], name: "index_contracts_on_previous_contract_id"
    t.index ["terminations_of_contract_id"], name: "index_contracts_on_terminations_of_contract_id"
  end

  create_table "passports", force: :cascade do |t|
    t.string "number", limit: 10
    t.date "date_of_issue"
    t.string "department_code", limit: 7
    t.date "date_of_birth"
    t.string "name", limit: 50
    t.string "surname", limit: 50
    t.string "middle_name", limit: 50
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_details", force: :cascade do |t|
    t.bigint "client_id"
    t.string "account_number", limit: 32
    t.string "BIK", limit: 32
    t.string "bank_name", limit: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_payment_details_on_client_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "label"
    t.integer "floor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tariffs", force: :cascade do |t|
    t.integer "price_per_day"
    t.date "start_date"
    t.bigint "box_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["box_type_id"], name: "index_tariffs_on_box_type_id"
  end

  create_table "terminations_of_contracts", force: :cascade do |t|
    t.float "client_debt"
    t.float "company_debt"
    t.date "termination_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "contracts", "contracts", column: "previous_contract_id"
end
