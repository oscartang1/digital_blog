Blog::Application.routes.draw do
    
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  
  match 'request/follow', :to => 'request#follow', :via => [:get]
  match 'users/:id', :to => 'users#show', :via => [:get], :as => 'users'
  match 'users/index', :to => 'users#index', :via => [:get]
  match 'reviews/new/:id', :to => 'reviews#new', :via => [:post], :as => 'reviews_new'
  match 'users/search', :to  => 'users#search', :via => [:post]
  
  resources :users do
	member do
      get :remove_request
      get :follow
      get :unfollow
      get :following
      get :followers
  	end
  end
  
  resources :follows
  resources :posts do
    member do
      get :like
      get :unlike
    end 
  end 
  
  
  resources :reviews
  resources :sessions
  resources :password_resets
  resources :request do
  get :confirm, :on => :collection
  get :reject, :on => :collection
end 
  
  root :to => 'posts#index'
  
end
