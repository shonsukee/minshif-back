class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships,   comment: "所属情報" do |t|
      t.integer  :user_id,       comment: "ユーザID"
      t.integer  :group_id,      comment: "グループID"
      t.boolean  :current_group, comment: "現在のグループかどうか", default: false

      t.timestamps
    end
  end
end
