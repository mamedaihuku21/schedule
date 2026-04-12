Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  authenticated :user do
    root "events#index", as: :authenticated_root
  end
  root "users/sessions#new"

  resources :categories, only: [:destroy]

  resources :events, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      get :detail
    end
    collection do
      get :day
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
