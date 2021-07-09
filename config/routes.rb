Rails.application.routes.draw do
  post "authenticate", to: "sessions#create"

  resources :users, only: [:create, :show] do
    collection do
      patch :update
    end
  end

  resources :posts, only: [:create]
end
