Rails.application.routes.draw do

  # 🔹 Deviseのログインページをrootに設定（エラー回避）
  devise_scope :user do
    root to: "devise/sessions#new"  # ✅ 修正：このブロック内で `root` を定義
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }, skip: [:passwords, :registrations] #明日おかしかったら消す

  get "/user/new", to: 'user#new', as: :expendable_items

  patch 'users/update_or_create', to: 'user#update_or_create', as: 'update_or_create_user'

  get "/user/confirm", to: 'user#confirm', as: :confirm_user

  #  https://c151-153-212-244-139.ngrok-free.app/users/sign_in
  
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
