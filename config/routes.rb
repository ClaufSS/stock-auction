Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users
  
  root to: 'lots#index'

  resources :auction_items, only: [:show, :new, :create]
  resources :lots, only: [:show, :new, :create] do
    post 'add', on: :member
    post 'remove', on: :member
    post 'approve', on: :member
    post 'bid', on: :member
    post 'cancel', on: :member
    post 'close', on: :member
    get 'expired', on: :collection
    get 'conquered', on: :collection
  end
end
