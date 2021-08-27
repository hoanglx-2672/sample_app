Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"
    get "/signup", to: "user#signUp", as: :signUp
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
