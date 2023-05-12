Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users
  
  root to: 'home#index'

  resources :auction_item, only: [:show, :new, :create], as: 'auction_items'
end

