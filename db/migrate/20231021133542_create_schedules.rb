class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
	create_table :schedules, comment: "個人スケジュール" do |t|
      t.integer  :user_id, 	 comment: "ユーザID",           null: false
      t.integer  :sl_id, 	 comment: "スケジュールリストID", null: false
      t.integer  :group_id,  comment: "グループID"
      t.date     :work_date, comment: "労働時間"

      t.timestamps
    end
  end
end
