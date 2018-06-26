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
  resources :teams do
    collection do
      post 'search'
      post 'apply'
      get 'apply_check'
      post 'permit_apply'
    end
  end
  resources :accounts
  resources :events do
    collection do
      post 'participate'
    end
  end
  resources :event_comments
end
