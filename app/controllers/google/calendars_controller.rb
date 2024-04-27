class Google::CalendarsController < ApplicationController
	require 'google/apis/calendar_v3'
	require 'googleauth'

	def create
		# TODO: 引数にする
		title = params[:title]
		access_token = params[:access_token]

		if !access_token
			render json: { error: 'access_tokenがありません' }
			return
		end

		# 店舗専用カレンダーを作成
		service = Google::Apis::CalendarV3::CalendarService.new
		service.authorization = access_token

		new_calendar = Google::Apis::CalendarV3::Calendar.new(
			summary: title,
			time_zone: 'Asia/Tokyo'
		)
		begin
			created_calendar = service.insert_calendar(new_calendar)
			# TODO: 内部処理に変更
			render json: { calendar_id: created_calendar }
		rescue Google::Apis::Error => e
			render json: { error: e.message }, status: internal_server_error
		end
	end

	def fetch_shift_info
		access_token = params[:access_token]
		calendar_id = params[:calendar_id]
		res = HTTParty.get("https://www.googleapis.com/calendar/v3/calendars/#{calendar_id}/events",
			headers: {
				'Authorization'	=> "Bearer #{access_token}",
				'Content-Type'	=> 'application/json'
			},
			query: {
				'timeMin'	=> '2024-03-01T00:00:00+09:00',
				'timeMax'	=> '2024-03-31T23:59:59+09:00'
			})
		response = JSON.parse(res.body)
		render json: { response: response }
	end
end
