Rails.application.routes.draw do

  devise_for :users
  scope module: :application do
    root 'main#index'

    namespace :api do
      get 'views/:view', action: :views
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

    namespace :api do
      get 'views/:view', action: :views
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
