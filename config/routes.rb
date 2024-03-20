Rails.application.routes.draw do
	namespace :user do
		get '/create', to: 'users#create'
		# 開発用
		get '/get_user_info', to: 'users#get_user_info'
	end

	# 開発用
	namespace :auth do
		get '/update', to: 'auths#update'
	end

	# 開発用
	namespace :google do
		get '/create', to: 'calendars#create'
		get '/fetch_info', to: 'calendars#fetch_shift_info'
	end
end
