Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, controller: "merchants/merchant_items", only: :index
      end
      resources :items
    end
  end
end
