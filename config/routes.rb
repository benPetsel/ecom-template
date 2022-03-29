Rails.application.routes.draw do
  resources :completed_orders
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
root "store#index"
 post "store/add_to_cart/:id", to: "store#add_to_cart", as: 'add_to_cart'
 post "store/delete_item/:id", to: "store#delete_item", as: 'delete_item'
 post "store/add_one/:id", to: "store#add_one", as: 'add_one'
 post "store/sub_one/:id", to: "store#sub_one", as: 'sub_one'
 post "store/shipping_info", to: "store#shipping_info", as: 'shipping_info'
 post "store/create", to: "store#create", as: 'store_create'
 get 'show', to: 'completed_orders#show', as: 'completed_orders_show'
 get 'contact', to: 'store#contact', as: 'contact'
 get 'store/store_show/:id', to: 'store#store_show', as: 'store_show'

 get 'cancel', to: 'store#cancel', as: 'store_cancel'
  get 'success', to: 'store#success', as: 'store_success'

  get "/store", to: "store#index"
  get "store/cart", as: 'cart'
  mount StripeEvent::Engine, at: '/stripe-webhooks'
  resources :webhooks, only: [:create]
  post "/webhook", to: "webhooks#create"
  # Defines the root path route ("/")
  # root "articles#index"
end
