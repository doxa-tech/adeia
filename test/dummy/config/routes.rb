Rails.application.routes.draw do

  root "articles#index"

  get 'login', to: "sessions#new"
  delete 'logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  resources :articles
end
