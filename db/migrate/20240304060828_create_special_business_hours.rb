class CreateSpecialBusinessHours < ActiveRecord::Migration[7.0]
  def change
    create_table :special_business_hours, comment: "特別営業日情報" do |t|
      t.references	:store,		foreign_key: true,	type: :string,	comment: "店舗情報の外部キー"
      t.date :special_date,		null: false, 						comment: "特別営業日"
      t.time :open_time,		null: false, 						comment: "開店時間"
      t.time :close_time,		null: false, 						comment: "閉店時間"
      t.string :notes,						 						comment: "備考"

      t.timestamps
    end
  end
end
