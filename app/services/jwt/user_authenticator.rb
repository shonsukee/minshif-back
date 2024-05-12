module Jwt::UserAuthenticator
	extend self

	def call(request_headers)
		@request_headers = request_headers
		return { error: I18n.t('jwt.invalid_headers') } if @request_headers['Authorization'].blank?

		begin
			# decodeしたトークン(payload)とヘッダー情報(_)を格納
			payload, = Jwt::TokenDecryptor.call(token)

			if payload.has_key?(:error)
				return payload
			end

			User.find(payload['user_id'])
		rescue StandardError => e
			{ error: e.message }
		end
	end

	private

	def token
		@request_headers['Authorization'].split(' ').last
	end
end
