Rails.application.routes.draw do
  namespace :admin do
    root to: 'competitions#index'

    get 'login', to: 'login#login'
    get 'logout', to: 'login#logout'

    resources :users

    resources :competitions do
      resources :dashboard, only: [:index]
      resources :competitors, shallow: true
      resources :events, shallow: true
      resources :news, shallow: true
    end
  end
end
