Rails.application.routes.draw do
  resource :session, only: :destroy
  resource :magic_signin, path: "sign-in", only: %i[ new create ]
  get "magic-session/:token", to: "magic_sessions#show", as: :magic_session
  resource :profile, only: %i[ show edit update ]
  resources :users, only: :show, param: :username
  resources :posts
  namespace :admin do
    root "dashboard#index"
    resources :users, only: %i[ update destroy ]
    resources :posts, only: :destroy
  end
  get "chat", to: "pages#chat"
  get "games", to: "pages#games"
  get "about", to: "pages#about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"
end
