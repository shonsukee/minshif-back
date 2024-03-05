class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores, id: :string, comment: "店舗情報" do |t|
      t.string :manager_id,		null: false,	comment: "管理者ID"
      t.string :calendar_id,					comment: "Google Calendar ID"
      t.string :store_name,		null: false,	comment: "店舗名"
      t.string :location,						comment: "場所"
      t.datetime :deleted_at,					comment: "削除日時"

      t.timestamps
    end
  end
end
