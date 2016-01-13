Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  
  get '/home', to: 'businesses#index'  
  
  get '/register', to: 'users#new'  
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  resources :users, only: [:create, :show]
 
  namespace :admin do
    get '/admin_panel', to: 'pages#admin_panel'
    resources :businesses, only: [:update, :edit, :destroy] do
      member do
        patch :approve_business
      end
    end
    resources :business_ownerships, only: [:destroy] do
      member do
        patch :approve
      end
    end
    resources :reviews, only: [:edit, :update, :destroy]
    resources :replies, only: [:edit, :update, :destroy]
    resources :categories, only: [:create, :new]
    resources :users, only: [:destroy]
  end
  
  namespace :business_owner do
    get '/admin_panel', to: 'pages#admin_panel'
    resources :businesses, only: [:edit, :update]
    resources :replies, only: [:new, :create]
  end
  
  resources :categories, only: [:show]
  
  resources :businesses, only: [:show, :new, :create] do
    collection do
      get '/search', to: 'businesses#search'
      get '/advanced_search', to: 'businesses#advanced_search', as: 'advanced_search'
    end
    resources :reviews, only: [:create]
  end  
  
  resources :business_ownerships, only: [:new, :create]
  
  resources :reviews, only: [:index]
  
  get '/favorites', to: 'favorites#index'
  resources :favorites, only: [:create, :destroy]  
  
  resources :recommendations, only: [:create, :new]
  
  get '/connections', to: 'connections#index'
  resources :connections, only: [:create, :destroy]
  
  resources :invitations, only: [:new, :create]
  
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'pages#expired_token'
end
