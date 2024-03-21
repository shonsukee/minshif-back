class ApplicationController < ActionController::API
	include ActionController::RequestForgeryProtection

	# 自動でCSRF対策する設定
	protect_from_forgery with: :null_session

	class AuthenticationError < StandardError; end

	rescue_from AuthenticationError, with: :unauthorized_token

	# 現在ログイン中のユーザ管理
	def authenticate
		raise AuthenticationError, t('defaults.message.require_login') unless current_user
	end

	private

	def current_user
		@current_user ||= Jwt::UserAuthenticator.call(request.headers)
	end

	def unauthorized_token(exception)
		render json: { error: { messages: exception.message } }, status: :unauthorized
	end
end
