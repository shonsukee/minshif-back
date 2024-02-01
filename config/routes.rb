Rails.application.routes.draw do
	# 開発用のルーティング
	get '/validate', to: 'auth#validate_access_token'
	get '/fetch_events', to: 'auth#fetch_events'
	get '/get_token', to: 'users#create'

	namespace 'api' do
		namespace 'v1' do
			namespace 'user' do
				get '/create', to: 'users#create'
				get '/update', to: 'users#update'
			end
		end
	end
end
