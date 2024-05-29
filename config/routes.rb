Rails.application.routes.draw do
	namespace 'user' do
		post '/create', to: 'users#create'
		post '/get_user_info', to: 'users#get_user_info'
	end

	namespace 'shift' do
		post '/submitShiftRequest', to: 'shift_submission_requests#create'
		post '/submit_shift_request/wanted', to: 'shift_submission_requests#wanted'
	end

	namespace 'store' do
		post '/create', to: 'store#create'
	end

	post '/invitation', to: 'invitations#create'
end
