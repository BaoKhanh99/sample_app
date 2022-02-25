Rails.application.routes.draw do
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/contact"
end
