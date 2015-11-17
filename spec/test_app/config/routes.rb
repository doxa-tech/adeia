Rails.application.routes.draw do
  mount Adeia::Engine => "/adeia"

  root "pages#dashboard"
  get "dashboard", to: "pages#dashboard"

  get "login", to: "sessions#new"
  get "logout", to: "sessions#destroy"
  resources :sessions, only: [:create]

  resources :articles
  resources :comments
end
