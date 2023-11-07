Rails.application.routes.draw do
	namespace 'api' do
		namespace 'v1' do
			get "/sign_up", to: "sign_up#index"
			post "/sign_up", to: "sign_up#create"

			get "/login", to: "login#index"
			post "/login", to: "login#create"
		end
	end
end
