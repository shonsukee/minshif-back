ActiveRecord::Schema[7.0].define(version: 2023_11_14_142550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "schedule_lists", comment: "予定のテンプレートリスト情報", force: :cascade do |t|
    t.uuid "user_id", comment: "ユーザIDの外部キー"
    t.string "title", comment: "予定のタイトル"
    t.text "description", comment: "予定の詳細"
    t.time "work_start", null: false, comment: "開始時間"
    t.time "work_end", null: false, comment: "終了時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedule_lists_on_user_id"
  end

  create_table "schedules", comment: "予定情報", force: :cascade do |t|
    t.bigint "membership_id", comment: "所属ID"
    t.string "title", comment: "予定のタイトル"
    t.text "description", comment: "予定の詳細"
    t.date "work_date", null: false, comment: "日付"
    t.time "work_start", null: false, comment: "開始時間"
    t.time "work_end", null: false, comment: "終了時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_schedules_on_membership_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "ユーザ情報", force: :cascade do |t|
    t.string "user_name", null: false, comment: "ユーザ名"
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "パスワード"
    t.integer "privilege", null: false, comment: "権限"
    t.string "remember_me_token", comment: "記憶トークン"
    t.datetime "remember_me_token_expired_at", comment: "記憶トークン有効期限"
    t.string "reset_password_token", comment: "パスワード再設定トークン"
    t.datetime "reset_password_token_expired_at", comment: "パスワード再設定トークン有効期限"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "schedule_lists", "users"
  add_foreign_key "schedules", "memberships"
end
