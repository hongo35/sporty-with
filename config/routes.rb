Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

   devise_scope :user do
     root 'devise/registrations#new'
     get '/users/sign_out' => 'devise/sessions#destroy'
   end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'registrations#new'

  resources :apis, only: [:index] do
    collection do
      post 'callback'
    end
  end

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
  resources :invites do
    collection do
      get 'member'
    end
  end
  resources :teams do
    member do
      get 'apply_check'
      get 'invite_member'
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
