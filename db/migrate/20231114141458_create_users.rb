class CreateUsers < ActiveRecord::Migration[7.0]
	def change
		enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
		create_table :users, id: :uuid, default: 'gen_random_uuid()', comment: "ユーザ情報" do |t|
			t.string		:user_name, 							null: false,	comment: "ユーザ名"
			t.string		:email,		index: { unique: true },	null: false,	comment: "メールアドレス"
			t.string		:picture,								null: false,	comment: "ユーザ写真URL"
			t.integer		:privilege,								null: false,	comment: "権限"
			t.datetime		:deleted_at,											comment: "削除日時"

			t.timestamps
		end
	end
end
