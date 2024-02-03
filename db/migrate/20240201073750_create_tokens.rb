class CreateTokens < ActiveRecord::Migration[7.0]
	def change
		create_table :tokens do |t|
			t.references	:user,	foreign_key: true,	type: :uuid,	comment: "ユーザIDの外部キー"
			t.text	:access_token,										comment: 'Google Calendar用アクセストークン'
			t.text	:refresh_token,										comment: 'Google Calendar用リフレッシュトークン'

			t.timestamps
		end
	end
end
