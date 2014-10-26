Rails.application.routes.draw do
  namespace :admin do
    root action: 'index'

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :users, except: [:show]

    resources :theme_files, only: [:edit, :update, :destroy] do
      member do
        get :show_image
      end
    end

    resources :themes do
      resources :theme_files, only: [:index, :new, :create] do
        collection do
          get :new_image
          post :create_image
        end
      end
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
          patch :remove_all_waiting
        end
      end

      resources :events, except: [:show] do
        resources :event_registrations, only: [:index, :destroy] do
          member do
            patch :update_waiting
          end
        end
      end

      resources :news, except: [:show]

      resources :theme_files, only: [:index, :new, :create] do
        collection do
          get :new_image
          post :create_image
        end
      end
    end
  end

  get '/:competition_handle/(:locale/(:theme_file))',
    to: 'competitions#theme_file',
    as: 'competition_area'
end
