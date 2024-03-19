class Auth::AuthsController < ApplicationController
	# 開発用
	# access_token更新
	def update
		token_service = TokenService.new()
		token_params = token_service.update_token(params[:email])
		render json: { response: "でけたよ" }
	end
end
