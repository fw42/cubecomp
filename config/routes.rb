Rails.application.routes.draw do
  admin_domain = Cubecomp::Application.config.admin_domain

  constraints HostRouteConstraint.new(admin_domain) do
    scope module: 'admin', as: 'admin', path: (admin_domain ? "/" : "/admin"), format: false do
      root action: 'index'

      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'

      resources :users, except: [:show]

      get :help, to: "help#index"

      theme_files_resources = lambda do
        member do
          get :show_image
        end

        collection do
          get :new_image
          post :create_image

          get :import_files, action: 'import_files_form'
          post :import_files
        end
      end

      resources :themes do
        resources :theme_files, except: [:show], &theme_files_resources
      end

      resources :competitions, except: [:show] do
        resources :dashboard, only: [:index]

        resources :competitors, except: [:show] do
          collection do
            get :checklist
            get :nametags
            get :email_addresses
            get :csv
            get :csv_download_active
          end

          member do
            patch :confirm
            patch :cancel
            patch :mark_as_paid
          end

          member do
            get 'email(/:activate)', to: 'competitor_email#new', as: 'new_email'
            post 'email', to: 'competitor_email#create', as: 'create_email'

            get 'email/render(.:format)(/:email_template_id)',
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
            delete 'destroy_day/:day_id', action: 'destroy_day', as: 'destroy_day'

            get :import_day, action: 'import_day_form'
            post :import_day
          end

          resources :event_registrations, only: [:index, :destroy] do
            member do
              patch :update_waiting
            end
          end
        end

        resources :news, except: [:show]
        resources :theme_files, except: [:show], &theme_files_resources

        resources :email_templates, except: [:show] do
          collection do
            get :import_templates, action: 'import_templates_form'
            post :import_templates
          end
        end
      end
    end
  end

  constraints HostRouteConstraint.new(admin_domain, negate: true) do
    scope '/wca' do
      get '/autocomplete/(:q.:format)',
        to: 'wca#autocomplete',
        as: 'wca_autocomplete',
        constraints: { format: 'json' }
    end

    get '/', to: "front_page#index"

    scope '/:competition_handle' do
      post '/:locale/registration',
        to: 'competition_area/competitors#create',
        as: 'competition_area_competitor_create'

      get '/(:locale/(:theme_file))',
        to: 'competition_area#render_theme_file',
        as: 'competition_area'
    end
  end
end
