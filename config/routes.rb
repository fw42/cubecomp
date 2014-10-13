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

      resources :competitors, except: [:show] do
        collection do
          get :checklist
          get :nametags
          get :email_addresses
          get :csv
        end
      end

      resources :event_registrations, only: [] do
        collection do
          get :waiting
        end
      end

      resources :events, except: [:show] do
        resources :event_registrations, only: [:index, :destroy] do
          member do
            patch :set_waiting
          end
        end
      end

      resources :news, except: [:show]
      resources :theme_files, except: [:show]
    end
  end

  get '/:competition_handle/(:locale/(:theme_file))',
    to: 'competitions#theme_file',
    as: 'competition_area'
end
