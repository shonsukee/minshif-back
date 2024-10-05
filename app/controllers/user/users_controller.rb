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

	def fetch_membership
		login_user = User.find_by(email: input_user_params[:email])
		if login_user.nil?
			render json: { error: I18n.t('user.users.get_user_info.failed') }, status: :bad_request
		end

		login_membership = Membership.with_users(login_user.id).current.first
		if login_membership.nil?
			render json: { error: I18n.t('user.users.fetch_membership.failed') }, status: :bad_request
		else
			render json: { membership: {
				id: login_membership[:id],
				user_id: login_membership[:user_id],
				store_id: login_membership[:store_id],
				current_store: login_membership[:current_store],
				calendar_id: login_membership[:calendar_id],
				privilege: login_membership[:privilege],
			} }
		end
	end

	private

	def input_params
		params.permit(:code, :invitation_id, user: [:id, :user_name, :email, :picture])
	end

	def input_user_params
		params.permit(:email)
	end
end
