Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "admin#index"
  get     "admin",         to: "admin#index",           as: :admin
  post    "admin/block",   to: "admin#block",           as: :block_admin
  post    "admin/unblock", to: "admin#unblock",         as: :unblock_admin
  post    "admin/delete",  to: "admin#delete_selected", as: :delete_admin
  post    "chat",          to: "chat#create",           as: :chat
  get     "login",         to: "sessions#new"
  post    "login",         to: "sessions#create"
  delete  "logout",        to: "sessions#destroy"
  get     "register",      to: "registrations#new"
  post    "register",      to: "registrations#create"
end
