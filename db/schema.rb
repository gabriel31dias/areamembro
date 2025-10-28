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

ActiveRecord::Schema[8.1].define(version: 2025_10_28_061343) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  create_table "course_progresses", force: :cascade do |t|
    t.integer "completed_lessons", default: 0
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "last_accessed_at"
    t.decimal "percentage", precision: 5, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["course_id"], name: "index_course_progresses_on_course_id"
    t.index ["user_id", "course_id"], name: "index_course_progresses_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_course_progresses_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title", null: false
    t.integer "total_lessons", default: 0
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["active"], name: "index_courses_on_active"
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "ebooks", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "author"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "pages", default: 0
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["active"], name: "index_ebooks_on_active"
    t.index ["user_id"], name: "index_ebooks_on_user_id"
  end

  create_table "lesson_progresses", force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.integer "lesson_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "watched_seconds", default: 0
    t.index ["lesson_id"], name: "index_lesson_progresses_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_lesson_progresses_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_lesson_progresses_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_minutes", default: 0
    t.integer "order_number", default: 0
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
    t.index ["course_id", "order_number"], name: "index_lessons_on_course_id_and_order_number"
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "plans", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_days", null: false
    t.json "features"
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["active"], name: "index_plans_on_active"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "payment_method"
    t.integer "plan_id"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["created_at"], name: "index_sales_on_created_at"
    t.index ["plan_id"], name: "index_sales_on_plan_id"
    t.index ["status"], name: "index_sales_on_status"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "user_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.integer "plan_id", null: false
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["expires_at"], name: "index_user_plans_on_expires_at"
    t.index ["plan_id"], name: "index_user_plans_on_plan_id"
    t.index ["user_id", "status"], name: "index_user_plans_on_user_id_and_status"
    t.index ["user_id"], name: "index_user_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_key"
    t.string "api_secret"
    t.datetime "blocked_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name"
    t.integer "owner_id"
    t.string "password_digest", null: false
    t.string "role", null: false
    t.string "status", default: "active"
    t.string "subscription_status", default: "free"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["owner_id"], name: "index_users_on_owner_id"
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
    t.index ["subscription_status"], name: "index_users_on_subscription_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "course_progresses", "courses"
  add_foreign_key "course_progresses", "users"
  add_foreign_key "courses", "users"
  add_foreign_key "ebooks", "users"
  add_foreign_key "lesson_progresses", "lessons"
  add_foreign_key "lesson_progresses", "users"
  add_foreign_key "lessons", "courses"
  add_foreign_key "plans", "users"
  add_foreign_key "sales", "plans"
  add_foreign_key "sales", "users"
  add_foreign_key "user_plans", "plans"
  add_foreign_key "user_plans", "users"
  add_foreign_key "users", "users", column: "owner_id"
end
