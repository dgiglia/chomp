Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  
  get '/home', to: 'businesses#index'  
  get '/register', to: 'users#new'  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]
  resources :businesses, only: [:show, :new, :create] do
    collection do
      get '/search', to: 'businesses#search'
    end
    resources :reviews, only: [:create]
  end
  
  resources :reviews, only: [:index]
  
end
