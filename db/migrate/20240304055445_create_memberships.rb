class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships, comment: "所属情報" do |t|
      t.references	:user,			foreign_key: true,	type: :string,	comment: "ユーザ情報の外部キー"
      t.references	:store,			foreign_key: true,	type: :string,	comment: "店舗情報の外部キー"
      t.boolean		:current_store,	default: false,						comment: "現在のグループ"

      t.timestamps
    end
  end
end
