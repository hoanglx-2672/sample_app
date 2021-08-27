Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"
    
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users do
      member do
      get :following, :followers
      end
    end
    resources :users
    resources :account_activations, only: :edit
    resources :relationships,only: [:create, :destroy]
    resources :password_resets, except: [:index, :show, :destroy]
    resources :microposts, only: [:create, :destroy]

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
