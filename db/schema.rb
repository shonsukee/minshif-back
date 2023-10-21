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

ActiveRecord::Schema[7.0].define(version: 2023_10_21_133542) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", comment: "グループ情報", force: :cascade do |t|
    t.string "group_name", comment: "グループ名"
    t.time "open_time", null: false, comment: "営業開始時間"
    t.time "close_time", null: false, comment: "営業終了時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", comment: "所属情報", force: :cascade do |t|
    t.integer "user_id", comment: "ユーザID"
    t.integer "group_id", comment: "グループID"
    t.boolean "current_group", default: false, comment: "現在のグループかどうか"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "privileges", comment: "権限", force: :cascade do |t|
    t.string "p_name", comment: "権限名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedule_lists", comment: "スケジュールのテンプレートリスト", force: :cascade do |t|
    t.integer "user_id", comment: "ユーザID"
    t.string "title", comment: "タイトル"
    t.text "description", comment: "詳細"
    t.time "work_start", null: false, comment: "開始時間"
    t.time "work_end", null: false, comment: "終了時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", comment: "個人スケジュール", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ユーザID"
    t.integer "sl_id", null: false, comment: "スケジュールリストID"
    t.integer "group_id", comment: "グループID"
    t.date "work_date", comment: "労働時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", comment: "ユーザ情報", force: :cascade do |t|
    t.string "user_name", comment: "ユーザ名"
    t.string "email", comment: "メールアドレス"
    t.string "password_digest", comment: "ハッシュ化パスワード"
    t.integer "privilege", default: 1, comment: "権限"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
