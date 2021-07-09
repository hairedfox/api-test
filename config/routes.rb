Rails.application.routes.draw do
  post "authenticate", to: "sessions#create"

  resources :users, only: [:create, :show] do
    collection do
      patch :update
    end
  end

  resources :posts, except: [:new, :edit] do
    resources :comments, only: [:create, :update, :destroy]
  end
end
