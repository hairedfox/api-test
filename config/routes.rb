Rails.application.routes.draw do
  post "authenticate", to: "sessions#create"

  resources :users, only: [:create]
end
