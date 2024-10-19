class CreateShiftChangeRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :shift_change_requests, comment: "シフト変更依頼情報" do |t|
      t.references	:shift,		foreign_key: true,	type: :bigint,	comment: "シフト情報の外部キー"
      t.string	:requestor,		null: false,						comment: "依頼者ID"
      t.string	:consenter,											comment: "承諾者ID"
      t.string	:status,		null: false,						comment: "状態"
      t.datetime :response_date,									comment: "返信日時"

      t.timestamps
    end
  end
end
