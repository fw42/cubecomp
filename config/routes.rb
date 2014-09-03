Rails.application.routes.draw do
  namespace :admin do
    root to: 'competitions#index'

    get 'login', to: 'login#login'
    get 'logout', to: 'login#logout'

    resources :competitions

    resources :users

    scope ':competition_id' do
      resources :dashboard, only: [:index]
      resources :competitors
      resources :events
      resources :news
    end
  end
end
