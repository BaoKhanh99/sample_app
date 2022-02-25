Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"


  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/contact"
end
