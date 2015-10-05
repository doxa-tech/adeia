Rails.application.routes.draw do
  mount Adeia::Engine => "/adeia"

  root "articles#index"

  get 'login', to: "sessions#new"
  get 'logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  resources :articles
end
