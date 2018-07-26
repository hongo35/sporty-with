Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

   devise_scope :user do
     get '/users/sign_out' => 'devise/sessions#destroy'
   end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :welcome do
    collection do
      get 'search'
    end
  end
  resources :home do
    collection do
      post 'ajax_push'
    end
  end
  resources :teams do
    member do
      get 'apply_check'
    end
    collection do
      post 'search'
      post 'apply'
      post 'permit_apply'
      post 'forbid_apply'
    end
  end
  resources :accounts
  resources :events do
    member do
      get 'report'
    end
    collection do
      post 'participate'
    end
  end
  resources :event_comments
  resources :event_reports
end
