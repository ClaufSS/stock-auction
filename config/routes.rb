Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users
  
  root to: 'auction_lots#index'

  resources :auction_items, only: [:show, :new, :create]

  resources :auction_lots, only: [:show, :new, :create] do
    resources 'auction_bids', only: [:create], as: 'create_bids'

    post 'add', on: :member
    post 'remove', on: :member
    post 'approve', on: :member
    post 'cancel', on: :member
    post 'close', on: :member
    get 'expired', on: :collection
    get 'conquered', on: :collection
  end
end
