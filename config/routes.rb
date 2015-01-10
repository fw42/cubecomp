Rails.application.routes.draw do
  namespace :admin, format: false do
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

        member do
          patch :confirm
          patch :disable
        end

        member do
          get 'email(/:activate)', to: 'competitor_email#new', as: 'new_email'
          post 'email', to: 'competitor_email#create', as: 'create_email'

          get 'email/render(/:email_template_id)',
            to: 'competitor_email#render_template',
            as: 'render_email',
            constraints: { format: 'json' }
        end
      end

      resources :event_registrations, only: [] do
        collection do
          get :waiting
          patch :remove_all_waiting
        end
      end

      resources :events, except: [:show] do
        collection do
          get 'print/(:day_id)', action: 'print', as: "print"
        end

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

      resources :email_templates, except: [:show]
    end
  end

  scope '/wca' do
    get '/autocomplete', to: 'wca#autocomplete', as: 'wca_autocomplete' #, constraints: { format: 'json' }
  end

  scope '/:competition_handle' do
    post '/:locale/register', to: 'competition_area/competitors#create', as: 'competition_area_competitor_create'
    get '/(:locale/(:theme_file))', to: 'competition_area#render_theme_file', as: 'competition_area'
  end
end
