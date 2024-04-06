Rails.application.routes.draw do
	namespace 'user' do
		post '/create', to: 'users#create'
		# 開発用
		get '/get_user_info', to: 'auth#get_user_info'
	end

	namespace 'shift' do
		post '/submitShiftRequest', to: 'shift_submission_requests#create'
	end
end
