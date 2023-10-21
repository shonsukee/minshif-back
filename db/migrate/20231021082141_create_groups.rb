class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups,     comment: "グループ情報" do |t|
      t.string   :group_name, comment: "グループ名"
      t.time     :open_time,  comment: "営業開始時間", null: false
      t.time     :close_time, comment: "営業終了時間", null: false

      t.timestamps
    end
  end
end
