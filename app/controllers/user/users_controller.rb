class User::UsersController < ApplicationController
	def create
		# GoogleAccessToken取得
		token_service = TokenService.new(input_params)
		token_params = token_service.get_token

		if token_params[:error].present?
			render json: { error: token_params[:error] }, status: :internal_server_error
			return
		end
		@token = Token.new(
			refresh_token: token_params[:refresh_token],
			access_token: token_params[:access_token],
		)

		# Googleアカウント情報取得
		user_params = get_user_info_with_google(@token.access_token)
		is_new_user = true
		if user_params[:error].present?
			render json: { error: user_params[:error] }, status: :internal_server_error
			return
		else
			user = User.find_by(email: user_params[:email]) if user_params[:email].present?
			# 既存ユーザの場合
			if user.present?
				token = Jwt::TokenProvider.call(user.id)
				memberships = Membership.where(user.id)
				is_new_user = false if memberships.count > 0
				render json: { msg: I18n.t('user.users.create.already_created'), token: token, user_id: user.id, is_new_user: is_new_user }
				return
			end
		end

		# ユーザを作成して登録
		@user = User.new(
			user_name: user_params[:name],
			email: user_params[:email],
			picture: user_params[:picture]
		)
		begin
			ActiveRecord::Base.transaction do
				@user.save!
				@user.create_token(@token.refresh_token, @token.access_token)
			end

			token = Jwt::TokenProvider.call(@user.id)
			render json: { token: token, user_id: @user.id, is_new_user: is_new_user }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }, status: :internal_server_error
		end
	end

	def get_user_info_with_google(access_token)
		url = 'https://www.googleapis.com/oauth2/v1/userinfo'
		headers = {
			Authorization: "Bearer #{access_token}"
		}
		begin
			res = HTTParty.get(url, headers: headers)
			if res.code == 200
				name = res.parsed_response['name']
				email = res.parsed_response['email']
				picture = res.parsed_response['picture']

				{ name: name, email: email, picture: picture }
			else
				{ error: 'API request failed', status: res.code }
			end
		rescue StandardError => e
			{ error: e.message, status: :internal_server_error }
		end
	end

	def get_user_info
		user_id = cookies[:user_id]
		user = User.find_by(id: user_id) if user_id.present?
		render json: { user: user }
	end

	private

	def input_params
		params.permit(:code, :scope, :authuser, :prompt)
	end
end
