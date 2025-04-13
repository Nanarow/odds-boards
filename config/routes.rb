Rails.application.routes.draw do
  get "designs" => "designs#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }, path_names: { sign_in: "login", sign_up: "register" }

  post "boards/new", to: "boards#new", as: :load_new_board
  resources :boards, only: [ :index, :create, :update, :destroy, :show ] do
    collection do
      get "@me" => "boards#my_boards", as: :my
      post :cancel_new
      post :search
    end
    member do
      post :upvote
      post :downvote
      post :publish
      post :draft
      post :make_public
      post :make_private
      post :edit, as: :load_edit
      post :cancel_edit
      post :confirm_delete
    end
  end

  resources :comments, only: [ :create, :update, :destroy ] do
    collection do
      post :cancel_new
    end
    member do
      post :upvote
      post :downvote
      post :edit, as: :load_edit
      post :cancel_edit
      post :confirm_delete
    end
  end

  resources :comments, as: :replies, only: [] do
    member do
      post :cancel_new_reply, as: :cancel_new
      post :new_reply, as: :new
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
