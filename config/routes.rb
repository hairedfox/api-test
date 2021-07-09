Rails.application.routes.draw do
  post "authenticate", to: "sessions#create"

  resources :users, only: [:create, :show] do
    collection do
      patch :update
    end
  end

  resources :posts, only: [:create, :show, :update, :destroy] do
    resources :comments, only: [:create, :update]
  end
end
