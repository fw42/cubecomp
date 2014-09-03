Rails.application.routes.draw do
  namespace :admin do
    root to: 'dashboard#index'

    get 'login', to: 'login#login'
    get 'logout', to: 'login#logout'

    resources :competitions
    resources :users

    scope ':competition_handle' do
      resources :competitors
      resources :events
      resources :news
    end
  end
end
