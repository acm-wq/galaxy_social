Rails.application.routes.draw do
  resources :stars, controller: 'stars', only: [:show, :create]

  # Defines the root path route ("/")
  # root "posts#index"
end
