# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_04_04_063517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "adminpack"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "completed_orders", force: :cascade do |t|
    t.string "order_id"
    t.integer "item_id"
    t.string "item_name"
    t.integer "quantity"
    t.integer "charge"
    t.text "address"
    t.string "rate_id"
    t.string "shipment_id"
    t.string "carrier_acct_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "email"
    t.string "session_identity"
    t.integer "secID"
    t.boolean "order_completed"
    t.string "recipient"
    t.string "color_options"
    t.integer "image_count"
  end

  create_table "images", force: :cascade do |t|
    t.string "sesh_id"
    t.integer "item_id"
    t.integer "secondary_id"
    t.boolean "purchased"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "instance_number"
  end

  create_table "managements", force: :cascade do |t|
    t.boolean "contact_page"
    t.boolean "about_page"
    t.text "about_text"
    t.text "shop_text"
    t.boolean "phone_card"
    t.text "phone_card_text"
    t.string "phone"
    t.string "brand_name"
    t.boolean "email_card"
    t.text "email_card_text"
    t.string "email"
    t.boolean "buisness_card"
    t.text "buisness_address"
    t.text "address_card_text"
    t.text "footer_text"
    t.text "home_page_text"
    t.boolean "testimonials"
    t.string "testimonial_1_name"
    t.text "testimonial_1_text"
    t.string "testimonial_2_name"
    t.text "testimonial_2_text"
    t.string "testimonial_3_name"
    t.text "testimonial_3_text"
    t.string "twitter"
    t.string "facebook"
    t.string "instagram"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ship_company"
    t.string "ship_city"
    t.string "ship_state"
    t.string "ship_zip"
    t.string "ship_street"
    t.float "tax_rate"
    t.string "title_tag"
    t.string "categories"
    t.boolean "cart_notice_inuse"
    t.string "cart_notice"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "catagory"
    t.text "description"
    t.integer "price"
    t.integer "old_price"
    t.boolean "on_sale"
    t.boolean "sold_out"
    t.boolean "featured"
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "length"
    t.integer "width"
    t.integer "height"
    t.integer "weight"
    t.string "secondary_heading"
    t.boolean "photos_attached"
    t.boolean "visible"
    t.boolean "dimensions_show"
    t.string "color_option_1"
    t.integer "image_number"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
