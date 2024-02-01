class AuthController < ApplicationController
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
			body['refresh_token']= token
			body['grant_type'] = 'refresh_token'
		else
			return { error: 'Invalid parameters' }
		end
		add_body = {
			client_id: ENV['GOOGLE_CLIENT_ID'],
			client_secret: ENV['GOOGLE_CLIENT_SECRET'],
			redirect_uri: 'http://localhost:3000/',
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
			render json: { res: "valid token!" }
		else
			render json: { res: "invalid token!" }
		end
	end

	# TODO: 引数から取得したイベント登録
	def fetch_events
		access_token = params[:access_token]
		res = HTTParty.get("https://www.googleapis.com/calendar/v3/calendars/primary/events", 
			headers: {
				"Authorization"	=> "Bearer #{access_token}",
				"Content-Type"	=> "application/json"
			},
			query: {
				'timeMin'	=> '2024-01-01T00:00:00Z',
				'timeMax'	=> '2024-01-31T23:59:59Z'
			})
		response = JSON.parse(res.body)

		schedule_list = response['items'].map { |e| e['summary'] }
		render json: { schedule_list: schedule_list }
	end
end
