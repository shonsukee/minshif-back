class Token < ApplicationRecord
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

	encrypts :refresh_token, :access_token

	def self.refresh_token_for_user(user_id)
		where(user_id: user_id).pluck(:refresh_token)
	end
end