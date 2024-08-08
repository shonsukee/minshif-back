class User::UsersController < ApplicationController
	def create
		result = UserService.create_with_token(input_params)
		if result[:success?]
			render json: { message: result[:message], is_affiliated: result[:is_affiliated] }, status: :ok
		else
			render json: { error: result[:error] }, status: :unprocessable_entity
		end
	end

	def get_user_info
		login_user = User.find_by(email: input_user_params[:email])
		if login_user.nil?
			render json: { error: I18n.t('user.users.get_user_info.failed') }, status: :bad_request
		else
			render json: { user: login_user }
		end
	end

	private

	def input_params
		params.permit(:code, :invitation_id, user: [:id, :name, :email, :picture])
	end

	def input_user_params
		params.permit(:email)
	end
end
