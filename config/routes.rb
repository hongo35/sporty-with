Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :welcome do
    collection do
      get 'search'
    end
  end
  resources :home
  resources :clubs do
    collection do
      get 'search'
    end
  end
  resources :groups do
    member do
      get 'entry'
    end
  end
  resources :events
  resources :event_comments
end
