class AuthCode < ApplicationRecord
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

	def self.create(auth_code, user_id)
		auth_record = find_or_initialize_by(user_id: user_id)
		auth_record.auth_code = auth_code

		auth_record.save
	end

	def self.index(user_id)
		expired = 30 * 60
		where(user_id: user_id)
			.where('updated_at > ?', Time.current - expired)
			.first
	end

	def auth_code_matches?(input_code)
		self.auth_code == input_code
	end
end