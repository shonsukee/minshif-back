class CreateScheduleLists < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_lists, comment: "スケジュールのテンプレートリスト" do |t|
      t.integer  :user_id,        comment: "ユーザID"
      t.string   :title,          comment: "タイトル"
      t.text 	 :description,    comment: "詳細"
      t.time     :work_start,     comment: "開始時間", null: false
      t.time     :work_end,       comment: "終了時間", null: false

      t.timestamps
    end
  end
end
