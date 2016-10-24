Adeia::Engine.routes.draw do

  resources :permissions, except: :show

  resources :tokens, except: :show

  resources :groups, except: :show

  resources :group_users, except: :show

end
