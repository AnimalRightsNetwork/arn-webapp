Rails.application.routes.draw do
  # Static pages
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/admin', to: 'static_pages#admin'

  # User login
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # User login
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Organization and event search
  resource :search, only: :show

  # Events
  resources :events, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    get 'map', on: :collection
    get 'calendar', on: :collection
  end

  # Administration
  scope '/admin' do
    # Organization types and tags
    namespace :orgs do
      resources :types, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :tags, only: [:index, :new, :create, :edit, :update, :destroy]
    end
    # Event types and tags
    namespace :events do
      resources :types, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :tags, only: [:index, :new, :create, :edit, :update, :destroy]
    end
    # Link types
    resources :link_types, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # Organizations
  resources :orgs, path: '/organizations', only: [:index, :new, :create]
  resources :orgs, id: /[A-Za-z0-9]{4,32}/, path: '/', only: [:show, :edit, :update, :destroy] do
    resources :events, only: [:index, :new] do
      get :map, on: :collection
      get :calendar, on: :collection
    end
  end
end
