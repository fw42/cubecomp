Rails.application.routes.draw do
  namespace :admin do
    root action: 'index'

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :users, except: [:show]

    resources :themes, only: [:index, :show] do
      resources :theme_file_templates, except: [:index, :show], shallow: true
    end

    resources :competitions, except: [:show] do
      resources :dashboard, only: [:index]
      resources :competitors, shallow: true
      resources :events, shallow: true
      resources :news, except: [:show], shallow: true
      resources :theme_files, except: [:show], shallow: true
    end
  end
end
