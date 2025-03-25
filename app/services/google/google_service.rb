module Google::GoogleService
	extend self

	def fetch_user_info(access_token)
		url = 'https://www.googleapis.com/oauth2/v1/userinfo'
		headers = {
			Authorization: "Bearer #{access_token}"
		}
		begin
			response = HTTParty.get(url, headers: headers)
			if response.code == 200
				user_name = response.parsed_response['name']
				email = response.parsed_response['email']
				picture = response.parsed_response['picture']

				{ user_name: user_name, email: email, picture: picture }
			else
				{ error: I18n.t('google.failed_api_request'), status: response.code }
			end
		rescue StandardError => e
			{ error: e.message, status: :internal_server_error }
		end
	end
end
