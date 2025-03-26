class UsersController < ApplicationController
	def index
		store = Store.find_by(id: params[:store_id])
		if store.nil?
			render json: { error: '店舗が存在しません' }, status: :not_found
			return
		end

		memberships = store.memberships.includes(:user)
		users = memberships.map do |membership|
			user = membership.user
			{
				id: user.id,
				privilege: membership.privilege,
				user_name: user.user_name,
				email: user.email,
				picture: user.picture
			}
		end

		render json: users
	end

	def create
		result = UserService.create_with_token(input_params)
		if result[:success?]
			render json: { message: result[:message], is_affiliated: result[:is_affiliated] }, status: :ok
		else
			render json: { error: result[:error] }, status: :unprocessable_entity
		end
	end

	def show
		user = User.find_by(email: input_user_params[:email])
		if user.nil?
			render json: { error: I18n.t('user.users.show.failed') }, status: :not_found
		else
			render json: user
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
