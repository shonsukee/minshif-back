class Google::CalendarsController < ApplicationController
	require 'google/apis/calendar_v3'
	require 'googleauth'

	def create
		# TODO: 引数にする
		title = params[:title]
		access_token = params[:access_token]

		if !access_token
			render json: { error: "access_tokenがありません" }
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
end
