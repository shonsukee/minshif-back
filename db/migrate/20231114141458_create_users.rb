class CreateUsers < ActiveRecord::Migration[7.0]
  def change
	enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid, default: 'gen_random_uuid()', comment: "ユーザ情報" do |t|
      t.string 		:user_name, 												null: false,	comment: "ユーザ名"
      t.string 		:email, 						index: { unique: true },	null: false,	comment: "メールアドレス"
      t.string 		:password_digest, 											null: false,	comment: "パスワード"
      t.integer		:privilege, 												null: false,	comment: "権限"
      t.string 		:remember_me_token, 			index: { unique: true },	null: true,		comment: "記憶トークン"
      t.datetime 	:remember_me_token_expired_at, 								null: true,		comment: "記憶トークン有効期限"
      t.string 		:reset_password_token, 			index: { unique: true },	null: true,		comment: "パスワード再設定トークン"
      t.datetime 	:reset_password_token_expired_at, 							null: true,		comment: "パスワード再設定トークン有効期限"
      t.datetime 	:deleted_at, 												null: true,		comment: "削除日時"

      t.timestamps
    end
  end
end
