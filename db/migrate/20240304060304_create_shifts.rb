class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts, comment: "シフト情報" do |t|
      t.references	:membership,	foreign_key: true,	type: :bigint,	comment: "所属情報の外部キー"
      t.date :shift_date,			null: false, 						comment: "希望日"
      t.time :start_time,			null: false, 						comment: "開始時間"
      t.time :end_time,				null: false, 						comment: "終了時間"
      t.text :notes,													comment: "備考"
      t.boolean :is_registered,		default: false, 					comment: "登録状態"

      t.timestamps
    end
  end
end
