module Jwt::TokenDecryptor
	extend self

	def call(token)
		decrypt(token)
	end

	private

	def decrypt(token)
		JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
	rescue JWT::DecodeError
		{ error: t('jwt.invalid_token') }
	end
end
