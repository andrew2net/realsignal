Rails.application.routes.draw do

  devise_for :users
  scope module: :application do
    root 'main#index'
    get :account, controller: :account, action: :index

    namespace :api do
      get 'views/:view', action: :views
      get :strategies
      get :equity_growth
    end
  end

  namespace :admin do
    root 'main#index'
    devise_for :admins, only: [:session]
    resources :admins, only: [:index, :create, :update, :destroy]
    resources :users, only: [:index, :create, :update, :destroy]
    resources :subscription_types, only: [:index, :create, :update, :destroy]
    resources :papers, only: [:index, :create, :update, :destroy]
    resources :tools, only: [:index, :create, :update, :destroy]
    resources :strategies, only: [:index, :create, :update, :destroy]
    resources :portfolio_strategies, only: [:index, :create, :update, :destroy]
    get 'recom_signals/index'

    namespace :api do
      get 'views/:view', action: :views
      post :create_signal
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
