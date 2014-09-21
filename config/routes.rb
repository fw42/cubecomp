Rails.application.routes.draw do
  namespace :admin do
    root action: 'index'

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :users, except: [:show]

    resources :themes, only: [:index, :show] do
      resources :theme_file_templates, except: [:index, :show]
    end

    resources :competitions, except: [:show] do
      resources :dashboard, only: [:index]
      resources :competitors
      resources :events
      resources :news, except: [:show]
      resources :theme_files, except: [:show]
    end
  end
end
