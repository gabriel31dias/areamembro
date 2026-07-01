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

ActiveRecord::Schema[8.1].define(version: 2026_07_01_150000) do
  create_table "active_storage_attachments", id: :string, force: :cascade do |t|
    t.string "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :string, force: :cascade do |t|
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

  create_table "active_storage_variant_records", id: :string, force: :cascade do |t|
    t.string "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", id: :string, force: :cascade do |t|
    t.string "activity_type", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.json "metadata", default: {}
    t.datetime "occurred_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["activity_type"], name: "index_activities_on_activity_type"
    t.index ["user_id", "occurred_at"], name: "index_activities_on_user_id_and_occurred_at"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "admins", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  create_table "certificates", id: :string, force: :cascade do |t|
    t.string "code", null: false
    t.string "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "issued_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["code"], name: "index_certificates_on_code", unique: true
    t.index ["course_id"], name: "index_certificates_on_course_id"
    t.index ["user_id", "course_id"], name: "index_certificates_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_certificates_on_user_id"
  end

  create_table "course_plans", id: :string, force: :cascade do |t|
    t.string "course_id", null: false
    t.datetime "created_at", null: false
    t.string "plan_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "plan_id"], name: "index_course_plans_on_course_id_and_plan_id", unique: true
    t.index ["course_id"], name: "index_course_plans_on_course_id"
    t.index ["plan_id"], name: "index_course_plans_on_plan_id"
  end

  create_table "course_progresses", id: :string, force: :cascade do |t|
    t.integer "completed_lessons", default: 0
    t.string "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "last_accessed_at"
    t.decimal "percentage", precision: 5, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["course_id"], name: "index_course_progresses_on_course_id"
    t.index ["user_id", "course_id"], name: "index_course_progresses_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_course_progresses_on_user_id"
  end

  create_table "courses", id: :string, force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title", null: false
    t.integer "total_lessons", default: 0
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.index ["active"], name: "index_courses_on_active"
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "ebooks", id: :string, force: :cascade do |t|
    t.boolean "active", default: true
    t.string "author"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "pages", default: 0
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.index ["active"], name: "index_ebooks_on_active"
    t.index ["user_id"], name: "index_ebooks_on_user_id"
  end

  create_table "lesson_progresses", id: :string, force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "lesson_id", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.integer "watched_seconds", default: 0
    t.index ["lesson_id"], name: "index_lesson_progresses_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_lesson_progresses_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_lesson_progresses_on_user_id"
  end

  create_table "lessons", id: :string, force: :cascade do |t|
    t.string "course_id", null: false
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

  create_table "plans", id: :string, force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_days", null: false
    t.json "features"
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.index ["active"], name: "index_plans_on_active"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "question_options", id: :string, force: :cascade do |t|
    t.boolean "correct", default: false
    t.datetime "created_at", null: false
    t.string "question_id", null: false
    t.string "text"
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order_number"
    t.string "quiz_id", null: false
    t.text "statement"
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quiz_attempts", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "passed"
    t.string "quiz_id", null: false
    t.integer "score"
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["quiz_id"], name: "index_quiz_attempts_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "quizzes", id: :string, force: :cascade do |t|
    t.string "course_id"
    t.datetime "created_at", null: false
    t.string "lesson_id"
    t.integer "passing_score", default: 70
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_quizzes_on_lesson_id", unique: true
  end

  create_table "sales", id: :string, force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "payment_method"
    t.string "plan_id"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["created_at"], name: "index_sales_on_created_at"
    t.index ["plan_id"], name: "index_sales_on_plan_id"
    t.index ["status"], name: "index_sales_on_status"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "themes", id: :string, force: :cascade do |t|
    t.string "background_color", default: "#070a13"
    t.datetime "created_at", null: false
    t.string "hero_highlight"
    t.string "hero_subtitle"
    t.string "hero_title"
    t.string "login_subtitle"
    t.string "login_title"
    t.string "member_area_title", default: "CATÁLOGO OFICIAL ALURADEV"
    t.string "muted_text_color", default: "#9ca3af"
    t.string "primary_color", default: "#6366f1"
    t.text "primary_description", default: "Aprenda no seu ritmo. Evolua com prática."
    t.string "secondary_color", default: "#a855f7"
    t.text "secondary_description", default: "Consulte abaixo somente os cursos disponíveis para sua conta, carregados diretamente da plataforma."
    t.string "surface_color", default: "#0e1424"
    t.string "text_color", default: "#f9fafb"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["user_id"], name: "index_themes_on_user_id", unique: true
  end

  create_table "user_achievements", id: :string, force: :cascade do |t|
    t.string "achievement_key", null: false
    t.datetime "created_at", null: false
    t.datetime "unlocked_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["user_id", "achievement_key"], name: "index_user_achievements_on_user_id_and_achievement_key", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_plans", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "plan_id", null: false
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["expires_at"], name: "index_user_plans_on_expires_at"
    t.index ["plan_id"], name: "index_user_plans_on_plan_id"
    t.index ["user_id", "status"], name: "index_user_plans_on_user_id_and_status"
    t.index ["user_id"], name: "index_user_plans_on_user_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "api_key"
    t.string "api_secret"
    t.datetime "blocked_at"
    t.string "cnpj_ou_cpf"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name"
    t.string "owner_id"
    t.string "password_digest", null: false
    t.string "role", null: false
    t.string "status", default: "active"
    t.string "subscription_status", default: "free"
    t.datetime "updated_at", null: false
    t.index ["cnpj_ou_cpf"], name: "index_users_on_cnpj_ou_cpf"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["owner_id"], name: "index_users_on_owner_id"
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
    t.index ["subscription_status"], name: "index_users_on_subscription_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "users"
  add_foreign_key "certificates", "courses"
  add_foreign_key "certificates", "users"
  add_foreign_key "course_plans", "courses"
  add_foreign_key "course_plans", "plans"
  add_foreign_key "course_progresses", "courses"
  add_foreign_key "course_progresses", "users"
  add_foreign_key "courses", "users"
  add_foreign_key "ebooks", "users"
  add_foreign_key "lesson_progresses", "lessons"
  add_foreign_key "lesson_progresses", "users"
  add_foreign_key "lessons", "courses"
  add_foreign_key "plans", "users"
  add_foreign_key "question_options", "questions"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quiz_attempts", "quizzes"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "quizzes", "courses"
  add_foreign_key "quizzes", "lessons"
  add_foreign_key "sales", "plans"
  add_foreign_key "sales", "users"
  add_foreign_key "themes", "users"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_plans", "plans"
  add_foreign_key "user_plans", "users"
  add_foreign_key "users", "users", column: "owner_id"
end
