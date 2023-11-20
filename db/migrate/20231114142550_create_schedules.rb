class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules, comment: "予定情報" do |t|
      t.references 	:membership,					foreign_key: true,	comment: "所属ID"
	  t.string 		:title,			null: true,							comment: "予定のタイトル"
      t.text 		:description,	null: true,							comment: "予定の詳細"
      t.date 		:work_date,		null: false,						comment: "日付"
      t.time 		:work_start,	null: false,						comment: "開始時間"
      t.time 		:work_end,		null: false,						comment: "終了時間"

      t.timestamps
    end
  end
end
