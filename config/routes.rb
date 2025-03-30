require 'sidekiq/web'

Rails.application.routes.draw do
	get '/', to: 'static_page#index'

	get '/users', to: 'users#show'
	post '/users', to: 'users#create'
	get '/stores/:store_id/users', to: 'users#index'

	get '/users/memberships', to: 'memberships#index'

	get '/preferred-shifts', to: 'preferred_shifts#index'
	post '/preferred-shifts', to: 'preferred_shifts#create'

	get '/shift-submission-requests', to: 'shift_submission_requests#wanted'
	post '/shift-submission-requests', to: 'shift_submission_requests#create'

	get '/users/:id/store-shifts', to: 'shifts#index'
	post '/shifts', to: 'shifts#create'

	get '/stores', to: 'stores#index'
	post '/stores', to: 'stores#create'

	post '/invitations', to: 'invitations#create'

	post '/', to: 'line_bots#callback'
	get '/bots/code', to: 'line_bots#index'
	post '/bots/code', to: 'line_bots#create'

	Sidekiq::Web.use(Rack::Auth::Basic) do |user_id, password|
		[user_id, password] == [ENV['SIDEKIQ_BASIC_AUTH_USER'], ENV['SIDEKIQ_BASIC_AUTH_PASSWORD']]
	end
	mount Sidekiq::Web => "/sidekiq"
end
