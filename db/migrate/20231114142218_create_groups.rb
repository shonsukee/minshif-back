class CreateGroups < ActiveRecord::Migration[7.0]
	def change
		enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
		create_table :groups, id: :uuid, default: 'gen_random_uuid()', comment: 'グループ情報' do |t|
			t.string	:group_name,	null: false,	comment: 'グループ名'
			t.time		:open_time,		null: false,	comment: '営業開始時間'
			t.time		:close_time,	null: false,	comment: '営業終了時間'
			t.datetime	:deleted_at,					comment: '削除日時'

			t.timestamps
		end
	end
end
