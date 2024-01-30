class AuthController < ApplicationController
	def get_token
		code = params[:code]
		if code.present?
			data = {
				code: code,
				client_id: ENV['GOOGLE_CLIENT_ID'],
				client_secret: ENV['GOOGLE_CLIENT_SECRET'],
				redirect_uri: 'http://localhost:8000/get_token', # TODO: リダイレクト先をカレンダーのページに変更！
				grant_type: 'authorization_code',
				access_type: 'offline'
			}

			headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
			url = 'https://www.googleapis.com/oauth2/v4/token'
			res = HTTParty.post(url, body: data, headers: headers)

			# TODO: refresh_tokenを取得し、データベースに保存する
			refresh_token = res.parsed_response['refresh_token']
			access_token = res.parsed_response['access_token']
		end
		render json: { refresh_token: refresh_token, access_token: access_token }
	end

	# 将来的にはcodeかrefresh_tokenかでトークン取得をハンドリング
	def get_access_token
		refresh_token = params[:refresh_token]
		data = {
			refresh_token: refresh_token,
			client_id: ENV['GOOGLE_CLIENT_ID'],
			client_secret: ENV['GOOGLE_CLIENT_SECRET'],
			redirect_uri: 'http://localhost:8000/get_token',
			grant_type: 'refresh_token',
			access_type: 'offline'
		}

		url = 'https://www.googleapis.com/oauth2/v4/token'
		headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
		res = HTTParty.post(url, body: data, headers: headers)

		# TODO: access_tokenを取得し、データベースに保存する
		access_token = res.parsed_response['access_token']
		if access_token.present?
		#   current_user.access_token = access_token
		#   current_user.save
			render json: { res: access_token }
		else
			render plain: ''
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
