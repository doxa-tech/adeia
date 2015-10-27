Adeia::Engine.routes.draw do

  resources :permissions, except: :show

  resources :tokens, except: :show

end