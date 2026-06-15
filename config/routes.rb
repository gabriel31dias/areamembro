Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Admin Panel Routes
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'dashboard', to: 'dashboard#index'
    root to: 'dashboard#index'
    
    resources :users do
      member do
        patch :block
        patch :unblock
      end
    end
  end

  # User Panel Routes (Mobile-First)
  namespace :panel do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'dashboard', to: 'dashboard#index'
    resources :courses do
      resources :lessons, except: [:index, :show] do
        resource :quiz, only: [:new, :create, :edit, :update, :destroy]
      end
    end
    resources :members
    resources :plans
    resources :ebooks
    
    # Settings / API Credentials
    get 'settings', to: 'settings#index'
    patch 'settings', to: 'settings#update'
    
    root to: 'dashboard#index'
  end

  # API routes
  namespace :api do
    namespace :v1 do
      # Provisionamento público de produtores (autorizado via header X-Api-Key)
      namespace :provisioning do
        resources :producers, only: [:create, :index]
      end

      namespace :auth do
        post 'admin/login', to: 'admins#login'
        post 'admin/signup', to: 'admins#signup'
        
        post 'user/login', to: 'users#login'
        post 'user/signup', to: 'users#signup'
        
        post 'member/login', to: 'members#login'
        post 'member/signup', to: 'members#signup'

        # Dados do usuário autenticado (qualquer role)
        get 'me', to: 'sessions#me'
      end

      # Public plans listing
      resources :plans, only: [:index]

      # Tema da área de membros (cores do produtor do member)
      resource :theme, only: [:show]

      # Histórico de atividades do member
      resources :activities, only: [:index]

      # Conquistas do member
      resources :achievements, only: [:index]

      # Courses routes (members only)
      resources :courses, only: [:index] do
        member do
          patch :update_progress
        end

        # Lessons for a specific course
        resources :lessons, only: [:index]
      end

      # Lesson progress update + quiz da aula
      resources :lessons, only: [] do
        member do
          patch :update_progress
        end
        # Quiz da aula
        resource :quiz, only: [:show]
      end

      # Submissão de quiz (dispara "Mestre dos Testes")
      resources :quizzes, only: [] do
        member do
          post :submit
        end
      end

      # Certificados do member
      resources :certificates, only: [:index, :show]

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

        # Plans management
        resources :plans
      end
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
