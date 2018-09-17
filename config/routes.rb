Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  match '/' => 'trade#index', :as => :root, via: [:get, :post]

  get '/exchange/:trade_pair', to: 'trade#trade'
  get '/reward', to: 'trade#reward'
  post '/exchange/get_init_data', to: 'trade#get_init_data'
  post '/exchange/get_messages', to: 'trade#get_messages'
  post '/exchange/create_order', to: 'trade#create_order'
  post '/exchange/get_orders', to: 'trade#get_orders'
  post '/exchange/get_signed_order', to: 'trade#get_signed_order'
  post '/exchange/create_trade_history', to: 'trade#create_trade_history'
  post '/exchange/get_trade_history', to: 'trade#get_trade_history'
  post '/exchange/delete_order', to: 'trade#delete_order'
  post '/exchange/get_matching_orders', to: 'trade#get_matching_orders'
  post '/exchange/update_order', to: 'trade#update_order'
  post '/exchange/get_my_open_orders', to: 'trade#get_my_open_orders'
  post '/exchange/delete_my_order', to: 'trade#delete_my_order'
  post '/exchange/find_token', to: 'trade#find_token'
  post '/exchange/get_owner_data', to: 'trade#get_owner_data'
  post '/exchange/delete_my_orders', to: 'trade#delete_my_orders'
  post '/exchange/get_token_info', to: 'trade#get_token_info'
  post '/exchange/get_tokens', to: 'trade#get_tokens'

  resources :trade do
    collection do
      match :trade, via: [:get, :post]
      post :get_init_data
      post :get_messages
      post :create_order
      post :get_orders
      post :get_signed_order
      post :create_trade_history
      post :get_trade_history
      post :delete_order
      post :get_matching_orders
      post :update_order
      post :get_my_open_orders
      post :delete_my_order
      post :find_token
      post :get_owner_data
      post :delete_my_orders
      post :get_token_info
      post :get_tokens
    end
  end

  post 'user_sessions/user_login'
  get 'user_sessions/get_user'

  mount API::Base, at: "/"  
  mount ActionCable.server => '/cable'

  Trestle::Engine.routes.draw do
    Trestle.admins.each do |name, admin|
      instance_eval(&admin.routes)
    end  
    root to: "trestle/dashboard#index"
  end
end
