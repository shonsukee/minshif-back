Rails.application.routes.draw do
	namespace :user do
		get '/create', to: 'users#create'
		# 開発用
		get '/get_user_info', to: 'users#get_user_info'
	end

	namespace :google do
		get '/create', to: 'calendars#create'
		get '/update', to: 'calendars#update'
	end
end
