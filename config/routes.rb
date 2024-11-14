require 'sidekiq/web'

Rails.application.routes.draw do
	get '/', to: 'static_page#index'

	namespace 'user' do
		post '/create', to: 'users#create'
		get '/get_user_info', to: 'users#get_user_info'
		get '/fetch_membership', to: 'users#fetch_membership'
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

	post '/', to: 'line_bots#callback'

	namespace 'line' do
		post '/auth_code', to: "line_bots#register_auth_code"
	end

	Sidekiq::Web.use(Rack::Auth::Basic) do |user_id, password|
		[user_id, password] == [ENV['SIDEKIQ_BASIC_AUTH_USER'], ENV['SIDEKIQ_BASIC_AUTH_PASSWORD']]
	end
	mount Sidekiq::Web => "/sidekiq"
end
