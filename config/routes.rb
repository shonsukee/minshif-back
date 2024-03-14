Rails.application.routes.draw do
	namespace 'user' do
		get '/create', to: 'users#create'
		# 開発用
		get '/get_user_info', to: 'auth#get_user_info'
	end
end
