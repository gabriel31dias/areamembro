Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post 'admin/login', to: 'admins#login'
        post 'admin/signup', to: 'admins#signup'
        
        post 'user/login', to: 'users#login'
        post 'user/signup', to: 'users#signup'
        
        post 'member/login', to: 'members#login'
        post 'member/signup', to: 'members#signup'
      end

      # Courses routes (members only)
      resources :courses, only: [:index] do
        member do
          patch :update_progress
        end
        
        # Lessons for a specific course
        resources :lessons, only: [:index]
      end

      # Lesson progress update
      resources :lessons, only: [] do
        member do
          patch :update_progress
        end
      end

      # Admin routes
      namespace :admin do
        # Courses management
        resources :courses, only: [:create, :update, :destroy] do
          resources :lessons, only: [:create]
        end
        resources :lessons, only: [:update, :destroy]

        # Users management
        resources :users do
          member do
            patch :block
            patch :unblock
            get :sales
          end
        end

        # Sales management
        resources :sales, only: [:index, :create, :update, :destroy]
      end
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
