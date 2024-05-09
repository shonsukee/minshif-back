class User::UsersController < ApplicationController
	def create
		result = UserService.create_with_token(input_params)
		if result[:success?]
			render json: { msg: result[:msg], token: result[:token], user_id: result[:user_id], is_new_user: result[:is_new_user] }
		else
			render json: { error: result[:error] }, status: result[:status]
		end
	end

	def get_user_info
		user_id = cookies[:user_id]
		user = User.find_by(id: user_id) if user_id.present?
		render json: { user: user }
	end

	private

	def input_params
		params.permit(:code)
	end
end
