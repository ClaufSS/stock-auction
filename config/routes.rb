Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users
  
  root to: 'home#index'

  resources :auction_items, only: [:show, :new, :create]
  resources :lots, only: [:show, :new, :create]
end
