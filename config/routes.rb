Rails.application.routes.draw do
	namespace 'user' do
		post '/create', to: 'users#create'
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

	namespace 'shift' do
		post '/submitShiftRequest', to: 'shift_submission_requests#create'
		post '/submit_shift_request/wanted', to: 'shift_submission_requests#wanted'
	end
end
