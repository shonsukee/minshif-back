class SessionController < ApplicationController
	before_action :redirect_to_home, only: [:new, :create]

	def create
		user = User.find_by(email: params[:email])
		if user.present? && user.authenticate(params[:password])
			flash[:notice] = 'ログインしました'
			session[:user_id] = user.id
			redirect_to sign_up_path
		else
			flash.now[:alert] = 'ログイン失敗しました'
			render 'new'
		end
	end

	private

	# TODO: home完成後，ログインしていなかったらbrank?で強制遷移するようにする, applicationcontrollerに
	def redirect_to_home
		redirect_to login_path if session[:user_id].present?
	end
end
