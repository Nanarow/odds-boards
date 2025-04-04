Rails.application.routes.draw do
  get "designs" => "designs#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }, path_names: { sign_in: "login", sign_up: "register" }

  resources :boards do
    collection do
      get "@me" => "boards#my_boards", as: :my
    end
    member do
      post :upvote
      post :downvote
      post :publish
      post :draft
      post :make_public
      post :make_private
    end
  end

  resources :comments, except: [ :index, :show, :new, :edit ] do
    member do
      post :upvote
      post :downvote
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root to: redirect("/boards")
end
