module Jwt::TokenProvider
	extend self

	def call(user_id)
		payload = {
			iss: ENV['JWT_ISS'],
			user_id: user_id,
			exp: (DateTime.current + 1.months).to_i
		}
		issue_token(payload)
	end

	private

	def issue_token(payload)
		JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
	end
end
