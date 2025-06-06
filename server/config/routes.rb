Rails.application.routes.draw do
  resources :stars, controller: 'stars', only: [:show, :create] do
    collection do
      get :random
      post 'planets', to: 'stars#add_planet'
    end
  end

  resources :planets, controller: 'planets', only: [ :show, :create ]

  # Authentication routes
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'

  # Defines the root path route ("/")
  # root "posts#index"
end
