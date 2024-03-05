class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :string, comment: "ユーザ情報" do |t|
      t.string		:user_name, 							null: false,	comment: "ユーザ名"
      t.string		:email,		index: { unique: true },	null: false,	comment: "メールアドレス"
      t.string		:picture,								null: false,	comment: "ユーザ写真URL"
      t.integer		:privilege,								null: false,	comment: "権限"
      t.datetime	:deleted_at,											comment: "削除日時"

      t.timestamps
    end
  end
end
