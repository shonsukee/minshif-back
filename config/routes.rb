Rails.application.routes.draw do
	# 開発用のルーティング
	get '/get_token', to: 'auth#get_token'
	get '/get_access_token', to: 'auth#get_access_token'
	get '/validate', to: 'auth#validate_access_token'
	get '/fetch_events', to: 'auth#fetch_events'

	namespace 'api' do
		namespace 'v1' do
		end
	end
end
