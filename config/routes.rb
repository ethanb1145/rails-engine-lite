Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do 
    namespace :v1 do 
      get "/items/:id/merchant", to: "items/merchants#show"
      get "/merchants/find", to: "merchants/search#find"
      get "/items/find", to: "items/search#find"
      get "/items/find_all", to: "items/search#find_all"
      get "/merchants/find_all", to: "merchants/search#find_all"

      resources :merchants, only: [:index, :show] do 
        resources :items, module: :merchants, only: [:index]
      end

      resources :items, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
