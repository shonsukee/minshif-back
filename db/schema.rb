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

ActiveRecord::Schema[7.0].define(version: 2024_01_29_050553) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "event_lists", comment: "予定のテンプレートリスト情報", force: :cascade do |t|
    t.uuid "user_id", comment: "ユーザIDの外部キー"
    t.string "title", comment: "予定のタイトル"
    t.text "description", comment: "予定の詳細"
    t.time "work_start", null: false, comment: "開始時間"
    t.time "work_end", null: false, comment: "終了時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", comment: "削除日時"
    t.index ["user_id"], name: "index_event_lists_on_user_id"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "グループ情報", force: :cascade do |t|
    t.string "group_name", null: false, comment: "グループ名"
    t.time "open_time", null: false, comment: "営業開始時間"
    t.time "close_time", null: false, comment: "営業終了時間"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", comment: "所属情報", force: :cascade do |t|
    t.uuid "user_id", comment: "ユーザIDの外部キー"
    t.uuid "group_id", comment: "グループIDの外部キー"
    t.boolean "current_group", default: false, comment: "現在のグループ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", comment: "削除日時"
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "ユーザ情報", force: :cascade do |t|
    t.string "user_name", null: false, comment: "ユーザ名"
    t.string "email", null: false, comment: "メールアドレス"
    t.integer "privilege", null: false, comment: "権限"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "access_token", comment: "Google Calendar用アクセストークン"
    t.text "refresh_token", comment: "Google Calendar用リフレッシュトークン"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "event_lists", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
end
