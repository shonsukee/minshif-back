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

ActiveRecord::Schema[7.0].define(version: 2024_04_04_082250) do
  create_table "business_hours", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "営業時間情報", force: :cascade do |t|
    t.string "store_id", comment: "店舗情報の外部キー"
    t.integer "day_of_week", null: false, comment: "曜日"
    t.time "open_time", null: false, comment: "開店時間"
    t.time "close_time", null: false, comment: "閉店時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_business_hours_on_store_id"
  end

  create_table "memberships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "所属情報", force: :cascade do |t|
    t.string "user_id", comment: "ユーザ情報の外部キー"
    t.string "store_id", comment: "店舗情報の外部キー"
    t.boolean "current_store", default: false, comment: "現在のグループ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "calendar_id"
    t.integer "privilege", null: false
    t.index ["store_id"], name: "index_memberships_on_store_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "shift_change_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "シフト変更依頼情報", force: :cascade do |t|
    t.bigint "shift_id", comment: "シフト情報の外部キー"
    t.string "requestor", null: false, comment: "依頼者ID"
    t.string "consenter", comment: "承諾者ID"
    t.string "status", null: false, comment: "状態"
    t.datetime "response_date", comment: "返信日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_shift_change_requests_on_shift_id"
  end

  create_table "shift_submission_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "シフト提出依頼情報", force: :cascade do |t|
    t.string "store_id", comment: "店舗情報の外部キー"
    t.date "start_date", null: false, comment: "開始日"
    t.date "end_date", null: false, comment: "最終日"
    t.date "deadline_date", comment: "締切日"
    t.time "deadline_time", comment: "締切時間"
    t.text "notes", comment: "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_shift_submission_requests_on_store_id"
  end

  create_table "shifts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "シフト情報", force: :cascade do |t|
    t.bigint "membership_id", comment: "所属情報の外部キー"
    t.date "shift_date", null: false, comment: "希望日"
    t.time "start_time", null: false, comment: "開始時間"
    t.time "end_time", null: false, comment: "終了時間"
    t.text "notes", comment: "備考"
    t.boolean "is_registered", default: false, comment: "登録状態"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_shifts_on_membership_id"
  end

  create_table "special_business_hours", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "特別営業日情報", force: :cascade do |t|
    t.string "store_id", comment: "店舗情報の外部キー"
    t.date "special_date", null: false, comment: "特別営業日"
    t.time "open_time", null: false, comment: "開店時間"
    t.time "close_time", null: false, comment: "閉店時間"
    t.string "notes", comment: "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_special_business_hours_on_store_id"
  end

  create_table "stores", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "店舗情報", force: :cascade do |t|
    t.string "store_name", null: false, comment: "店舗名"
    t.string "location", comment: "場所"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "シフトのテンプレート情報", force: :cascade do |t|
    t.string "user_id", comment: "ユーザ情報の外部キー"
    t.time "start_time", null: false, comment: "開始時間"
    t.time "end_time", null: false, comment: "終了時間"
    t.text "notes", comment: "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "トークン情報", force: :cascade do |t|
    t.string "user_id", comment: "ユーザ情報の外部キー"
    t.text "access_token", comment: "アクセストークン"
    t.text "refresh_token", comment: "リフレッシュトークン"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "ユーザ情報", force: :cascade do |t|
    t.string "user_name", null: false, comment: "ユーザ名"
    t.string "email", null: false, comment: "メールアドレス"
    t.string "picture", null: false, comment: "ユーザ写真URL"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "business_hours", "stores"
  add_foreign_key "memberships", "stores"
  add_foreign_key "memberships", "users"
  add_foreign_key "shift_change_requests", "shifts"
  add_foreign_key "shift_submission_requests", "stores"
  add_foreign_key "shifts", "memberships"
  add_foreign_key "special_business_hours", "stores"
  add_foreign_key "templates", "users"
  add_foreign_key "tokens", "users"
end
