require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'devise_customizations/registrations',
    sessions: 'devise_customizations/sessions',
  }
  mount ActionCable.server => '/cable'

  get '/chat', to: 'chat#index'
  resources :users do
    member do
      get 'analytics_alias'
    end
    collection do
      get 'edit_password'
      patch 'update_password'
    end
  end

  resources :images, only: [:create]

  namespace :admin do
    root to: 'users#index'

    resources :users do
      member do
        get 'impersonate'
        post 'test_push_notification'
      end

      collection do
        get 'stop_impersonating'
      end
    end
    resources :addresses
    resources :attachments
    resources :authentication_tokens
    resources :images
  end

  authenticated :user do
    # root to: 'dashboard#show', as: :authenticated_root
    root to: 'high_voltage/pages#show', id: 'welcome', as: :authenticated_root
  end

  devise_scope :user do
    get 'sign-in',  to: 'devise_customizations/sessions#new'
    post 'api/v1/authentication_tokens',  to: 'devise_customizations/sessions#create'
    post 'api/v1/password_resets', to: 'devise_customizations/passwords#create'

    get 'sign-out', to: 'devise/sessions#destroy'
  end
  root 'high_voltage/pages#show', id: 'welcome'

  # API-specific routes
  namespace 'api' do
    namespace 'v1' do
      jsonapi_resources :users, except: [:new, :edit]
      namespace 'users' do
        jsonapi_resources :passwords, except: [:show, :create, :index, :destroy]
      end
    end
  end

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?

  mount Sidekiq::Web => '/sidekiq'
end
