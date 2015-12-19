Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  
  get '/home', to: 'businesses#index'  
  get '/register', to: 'users#new'  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  get '/favorites', to: 'favorites#index'
  resources :favorites, only: [:create, :destroy]
  
  get '/connections', to: 'connections#index'
  resources :connections, only: [:create, :destroy]
  
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]
  resources :businesses, only: [:show, :new, :create] do
    collection do
      get '/search', to: 'businesses#search'
    end
    resources :reviews, only: [:create]
  end
  
  resources :reviews, only: [:index]
  
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'pages#expired_token'
  
  resources :invitations, only: [:new, :create]
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  
end
