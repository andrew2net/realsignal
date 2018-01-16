Rails.application.routes.draw do

  telegram_webhooks TelegramController
  devise_for :users
  scope module: :application do
    root 'main#index'
    post :tcwh, controller: :tcwh, action: :webhook

    namespace :account do
      get :dashboard, action: :index, controller: :dashboard # #, controller: :account, action: :index
      resources :subscriptions do
        collection do
          get :select_plan
          get :plans
          get :billing_addr
          post :billing_addr, action: :save_billing_addr
          get :success
        end
      end
    end

    namespace :api do
      get 'views/:view', action: :views
      get :strategies
      get :equity_growth
      get :telegram_token
    end
  end

  namespace :admin do
    root 'main#index'
    devise_for :admins, only: [:session]
    resources :admins, only: [:index, :create, :update, :destroy]
    resources :users, only: [:index, :create, :update, :destroy]
    resources :subscription_types, only: [:index, :create, :update, :destroy] do
      get :periods, on: :collection
    end
    resources :papers, only: [:index, :create, :update, :destroy]
    resources :tools, only: [:index, :create, :update, :destroy]
    resources :strategies, only: [:index, :create, :update, :destroy]
    resources :portfolio_strategies, only: [:index, :create, :update, :destroy]
    resources :subscriptions, only: [:index, :create, :update, :destroy]
    get 'recom_signals/index'

    namespace :api do
      get 'views/:view', action: :views
      get :current_admin_email
      post :create_signal
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
