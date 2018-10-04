Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  match '/' => 'exchange#index', :as => :root, via: [:get, :post]

  get '/exchange/:trade_pair', to: 'exchange#trade'
  get '/reward', to: 'exchange#reward'
  get '/whitepaper/:lang', to: 'exchange#download_whitepaper'
  

  resources :exchange do
    collection do
      match :trade, via: [:get, :post]
      post :get_init_data
      post :get_reward
      post :request_reward
      post :get_users
      get :get_reward
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
