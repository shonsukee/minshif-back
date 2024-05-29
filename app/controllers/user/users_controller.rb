class User::UsersController < ApplicationController
	before_action :authenticate, only: [:get_user_info]

	def create
		result = UserService.create_with_token(input_token_params, input_invitation_params)
		if result[:success?]
			render json: { msg: result[:msg], token: result[:token], user_id: result[:user_id], is_new_user: result[:is_new_user] }
		else
			render json: { error: result[:error] }, status: :unprocessable_entity
		end
	end

	def get_user_info
		if @current_user
			render json: { user: @current_user }
		else
			render json: { error: I18n.t('user.users.get_user_info.failed') }, status: bad_request
		end
	end

	private

	def input_token_params
		params.permit(:code)
	end

	def input_invitation_params
		params.permit(:invitation_id)
	end
end
