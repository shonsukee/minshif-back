class User::UsersController < ApplicationController
	before_action :authenticate, only: [:get_user_info]

	def create
		result = UserService.create_with_token(input_params)
		if result[:success?]
			render json: { message: result[:message], is_affiliated: result[:is_affiliated] }, status: :ok
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

	def input_params
		params.permit(:code, :invitation_id, user: [:id, :name, :email, :picture])
	end
end
