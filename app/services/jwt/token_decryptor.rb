module Jwt::TokenDecryptor
	extend self

	def call(token)
		decrypt(token)
	end

	private

	def decrypt(token)
		begin
			JWT.decode(token, Rails.application.credentials.secret_key_base, true, { iss: ENV['JWT_ISS'], verify_iss: true, algorithm: 'HS256' })
		rescue JWT::ExpiredSignature
			{ error: I18n.t('jwt.expired_token') }
		rescue JWT::InvalidIssuerError
			{ error: I18n.t('jwt.invalid_token') }
		rescue JWT::DecodeError
			{ error: I18n.t('jwt.invalid_token') }
		end
	end
end
