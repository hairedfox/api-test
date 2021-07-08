Rails.application.routes.draw do
  post "authenticate", to: "sessions#create"
end
