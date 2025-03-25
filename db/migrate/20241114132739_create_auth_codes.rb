class CreateAuthCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_codes do |t|
      t.references	:user,	foreign_key: true,	type: :string,	comment: "ユーザ情報の外部キー"
      t.string :auth_code,	null: false, comment: "LINE Bot用認証コード"

      t.timestamps
    end
  end
end
