Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, controller: "merchants/merchant_items", only: :index
      end
      get '/items/find', to: "items/search#show"
      resources :items do
        get '/merchant', to: "items/items_merchant#show"
      end
    end
  end
end
