class User < ApplicationRecord
	include IdGenerator

	has_many :tokens, dependent: :destroy
	has_many :memberships
	has_many :auth_codes
	has_many :templates

	validates :user_name, presence: true, length: {maximum: 200}
	validates :email, presence: true, uniqueness: true

	def create_token(refresh_token, access_token)
		tokens.create(refresh_token: refresh_token, access_token: access_token)
	end

	def update_access_token(new_access_token)
		tokens.update(access_token: new_access_token)
	end

	def send_invite_email(invitee_user, invite_link, manager)
		begin
			UserMailer.invitation(invitee_user, invite_link, manager).deliver_now!
		rescue StandardError => e
			e.message
		end
	end

	def self.register_line_id(user_id, line_user_id)
		user = find_by(id: user_id)

		if user
			user.update(line_user_id: line_user_id)
			true
		else
			false
		end
	end
end
