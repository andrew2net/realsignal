Rails.application.routes.draw do
  scope module: :application do
    root 'main#index'
    namespace :api do
      get 'views/:view', action: :views
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
