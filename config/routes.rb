Rails.application.routes.draw do
  get "mypages/show"
  
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }, skip: [:passwords, :registrations]

  # 🔹 Deviseのログインページをrootに設定（エラー回避）
  devise_scope :user do
    authenticated :user do
      root to: "user#confirm", as: :authenticated_root
    end
    # 未ログインユーザーは sign_in
    unauthenticated do
      root to: "devise/sessions#new"
    end
  end

  # 証人画面 > 新規ページ
  get "/user/new", to: 'user#new', as: :expendable_items

  # 新規作成ページから入力データを読み込みテーブルに保存
  patch 'users/update_or_create', to: 'user#update_or_create', as: 
  'update_or_create_user'
  # 新規ページ > プロフィール作成確認ページ
  get "/user/confirm", to: 'user#confirm', as: :confirm_user
  # 確認ページ確認ボタン押した後、プロフィールテーブルcomplete: ture
  patch "user/confirm_messes", to: "user#confirm_messes", as: :complete_profile
  # プロフィール確認ページ > メッセージページ
  get "user/thank_you", to: "user#thank_you", as: :thank_you

  # マイページ
  resource :mypage, only: [:show]


  # https://4430-153-222-142-57.ngrok-free.app/users/sign_in
  # https://line-text-d66b83e480a5.herokuapp.com/users/auth/line/callback コールバッグメモ
  
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
