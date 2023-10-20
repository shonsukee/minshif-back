Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/sign_up", to: "users#new"
  post "/sign_up", to: "users#create"

  get "/login", to: "session#new"
  post "/login", to: "session#create"
end
