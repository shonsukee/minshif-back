Rails.application.routes.draw do
	namespace 'user' do
		post '/create', to: 'users#create'
		get '/get_user_info', to: 'users#get_user_info'
	end

	namespace 'shift' do
		post '/preferred_shifts', to: 'preferred_shifts#create'

		post '/submitShiftRequest', to: 'shift_submission_requests#create'
		get '/fetch_shift_request', to: 'shift_submission_requests#wanted'

		get '/fetch_shifts', to: 'shifts#fetch_shifts'

		post '/register_draft_shifts', to: 'draft_shifts#create'
	end

	namespace 'store' do
		post '/create', to: 'store#create'
		get '/staff_list', to: 'store#fetch_staff_list'
	end

	post '/invitation', to: 'invitations#create'
end
