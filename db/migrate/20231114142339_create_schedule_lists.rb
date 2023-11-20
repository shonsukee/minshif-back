class CreateScheduleLists < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_lists, comment: "予定のテンプレートリスト情報" do |t|
      t.references 	:user,			type: :uuid,	foreign_key: true,	comment: "ユーザIDの外部キー"
      t.string 		:title,			null: true,							comment: "予定のタイトル"
      t.text 		:description,	null: true,							comment: "予定の詳細"
      t.time 		:work_start,	null: false,						comment: "開始時間"
      t.time 		:work_end,		null: false,						comment: "終了時間"

      t.timestamps
    end
  end
end
