class TokenService
	def initialize(params)
	  @params = params
	end

	def get_token
		url = 'https://www.googleapis.com/oauth2/v4/token'
		body = {}
		code = @params[:code] if @params.key?(:code)
		token = @params[:refresh_token] if @params.key?(:refresh_token)
		if code.present? && token.present?
			return { error: 'Invalid parameters' }
		elsif code.present?
			body['code']= code
			body['grant_type'] = 'authorization_code'
		elsif token.present?
			body['refresh_token']= token.is_a?(Array) ? token.first : token
			body['grant_type'] = 'refresh_token'
		else
			return { error: 'No valid parameters' }
		end
		add_body = {
			client_id: ENV['GOOGLE_CLIENT_ID'],
			client_secret: ENV['GOOGLE_CLIENT_SECRET'],
			redirect_uri: 'http://localhost:3000/redirect',
			access_type: 'offline'
		}
		body = body.merge(add_body)
		headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

		# Googleのトークン取得
		begin
			res = HTTParty.post(url, body: body, headers: headers)
			if res.code == 200
				refresh_token = res.parsed_response['refresh_token']
				access_token = res.parsed_response['access_token']

				{ refresh_token: refresh_token, access_token: access_token }
			else
				{ error: res, status: res.code }
			end
		rescue StandardError => e
			{ error: e.message, status: :internal_server_error}
		end
	end

	def validate_access_token
		access_token = params[:access_token]
		url = 'https://www.googleapis.com/oauth2/v3/tokeninfo'
		res = HTTParty.get(url, query: { 'access_token' => access_token })

		if res.parsed_response['error_description'].nil?
			true
		else
			false
		end
	end

	def update_token
		user = User.find_by(email: update_params[:email])
		if user
			refresh_token = user.tokens.refresh_token_for_user(user.id)
			if refresh_token.blank?
				return { error: 'refresh token is empty' }
			end

			# access_tokenを更新
			token_params = AuthController.new(refresh_token: refresh_token).get_token
			if token_params[:error].present?
				return { error: token_params[:error] }, status: :internal_server_error
			end
			user.update_access_token(token_params[:access_token])

			true
		else
			{ error: 'User not found.' }
		end
	end

	private

	def update_params
		params.permit(:email, :refresh_token)
	end
end