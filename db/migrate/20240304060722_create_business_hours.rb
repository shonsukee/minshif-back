class CreateBusinessHours < ActiveRecord::Migration[7.0]
  def change
    create_table :business_hours, comment: "営業時間情報" do |t|
      t.references	:store,		foreign_key: true,	type: :string,	comment: "店舗情報の外部キー"
      t.integer :day_of_week,	null: false, 						comment: "曜日"
      t.time :open_time,		null: false, 						comment: "開店時間"
      t.time :close_time,		null: false, 						comment: "閉店時間"

      t.timestamps
    end
  end
end
