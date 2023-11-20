class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships, comment: "所属情報" do |t|
      t.references 	:user,			foreign_key: true,	type: :uuid,	comment: "ユーザIDの外部キー"
      t.references 	:group,			foreign_key: true,	type: :uuid,	comment: "グループIDの外部キー"
      t.boolean 	:current_group,	default: false,						comment: "現在のグループ"

      t.timestamps
    end
  end
end
