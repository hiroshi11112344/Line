Rails.application.routes.draw do
  root to: "homes#index"
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }, skip: [:passwords, :registrations] #明日おかしかったら消す

  get "/user/new", to: 'user#new', as: :expendable_items
  post "/user", to: 'user#create', as: :users
  

  #  https://3057-153-212-244-139.ngrok-free.app/users/sign_in
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"


end
