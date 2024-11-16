class AuthCode < ApplicationRecord
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

	def self.register_auth_code(auth_code, user_id)
		auth_record = find_or_initialize_by(user_id: user_id)
		auth_record.auth_code = auth_code

		if auth_record.save
			true
		else
			false
		end
	end

	def self.fetch_auth_code(user_id)
		expired = 30 * 60
		where(user_id: user_id)
			.where('updated_at > ?', Time.current - expired)
			.first
	end

	def auth_code_matches?(input_code)
		self.auth_code == input_code
	end
end