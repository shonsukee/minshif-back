class Api::V1::SignUpController < ApplicationController

	def index
		users = User.all
		render json: users
	end

	def new
		@user = User.new
	end

	def create
		user_params = params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
		@user = User.new(user_params)
		if @user.save
			flash[:notice] = "登録しました"
			redirect_to login_path
		else
			flash.now[:alert] = "登録に失敗しました"
			render "new"
		end
	end
end
