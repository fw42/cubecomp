Rails.application.routes.draw do
  namespace :admin do
    root to: 'dashboard#index'

    get 'login', to: 'login#login'
    get 'logout', to: 'login#logout'

    resources :users

    resources :competitions, except: [:show] do
      resources :dashboard, only: [:index]
      resources :competitors, shallow: true
      resources :events, shallow: true
      resources :news, except: [:show], shallow: true
      resources :theme_files, except: [:show], shallow: true
    end
  end
end
