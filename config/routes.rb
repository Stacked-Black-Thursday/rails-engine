Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find_all', to: 'merchants/search#index'
      get 'revenue/merchants/:id', to: 'merchants#revenue_by_merchant'
      get 'revenue/merchants', to: 'merchants#most_revenue'
      get 'revenue/unshipped', to: 'invoices#unshipped_revenue'

      resources :merchants, only: [:index, :show] do
        resources :items, controller: "merchants/merchant_items", only: :index
      end

      get 'items/find', to: "items/search#show"
      get 'revenue/items', to: 'items#most_revenue'

      resources :items do
        get 'merchant', to: "items/items_merchant#show"
      end
    end
  end
end
