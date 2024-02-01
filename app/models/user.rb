class User < ApplicationRecord
	# has_many :token, dependent: :destroy
	validates :user_name, presence: true, length: {maximum: 200}
	validates :email, presence: true, uniqueness: true

	def update_access_token(new_access_token)
		# access_token = access_token.last
		# access_token.update(access_token: new_access_token) if access_token
		update(access_token: new_access_token)
	end
end
