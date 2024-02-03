class User < ApplicationRecord
	has_many :tokens, dependent: :destroy

	validates :user_name, presence: true, length: {maximum: 200}
	validates :email, presence: true, uniqueness: true

	def create_token(refresh_token, access_token)
		tokens.create(refresh_token: refresh_token, access_token: access_token)
	end

	def update_access_token(new_access_token)
		tokens.update(access_token: new_access_token)
	end
end
