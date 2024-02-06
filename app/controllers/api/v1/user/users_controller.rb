class Api::V1::User::UsersController < ApplicationController
	def create
		# GoogleAccessToken取得
		token_params = AuthController.new(input_params).get_token
		if token_params[:error].present?
			render json: { error: token_params[:error] }, status: :internal_server_error
			return
		end
		@token = Token.new(
			refresh_token: token_params[:refresh_token],
			access_token: token_params[:access_token],
		)

		# Googleアカウント情報取得
		user_params = get_user_info(@token.access_token)
		if user_params[:error].present?
			render json: { error: user_params[:error] }, status: :internal_server_error
			return
		elsif User.find_by(email: user_params[:email]).present?
			render json: { message: "User has already been created." }
			return
		end

		# ユーザを作成して登録
		@user = User.new(
			user_name: user_params[:name],
			email: user_params[:email],
			picture: user_params[:picture],
			privilege: 1
		)

		begin
			ActiveRecord::Base.transaction do
				@user.save!
				@user.create_token(@token.refresh_token, @token.access_token)
			end
			render json: { res: 'User create successflly.' }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }
		end
	end

	def get_user_info(access_token)
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

	def update
		user = User.find_by(email: update_params[:email])
		if user
			refresh_token = user.tokens.refresh_token_for_user(user.id)
			if refresh_token.blank?
				render json: { error: 'refresh token is empty' }
				return
			end

			# access_tokenを更新
			token_params = AuthController.new(refresh_token: refresh_token).get_token
			if token_params[:error].present?
				render json: { error: token_params[:error]}, status: :internal_server_error
				return
			end
			user.update_access_token(token_params[:access_token])

			render json: { message: 'Access token updated successflly.' }
		else
			render json: { error: 'User not found.' }
		end
	end

	private

	def input_params
		params.permit(:code, :scope, :authuser, :prompt)
	end

	def update_params
		params.permit(:email, :refresh_token)
	end
end
