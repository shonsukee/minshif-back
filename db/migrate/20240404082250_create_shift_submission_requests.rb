class CreateShiftSubmissionRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :shift_submission_requests, comment: "シフト提出依頼情報"  do |t|
      t.references :store,	foreign_key: true, type: :string,	comment: "店舗情報の外部キー"
      t.date :start_date,		null: false,					comment: "開始日"
      t.date :end_date,			null: false,					comment: "最終日"
      t.date :deadline_date,									comment: "締切日"
      t.time :deadline_time,									comment: "締切時間"
      t.text :notes,											comment: "備考"

      t.timestamps
    end
  end
end
