Rails.application.routes.draw do
  resources :managements
  resources :images
  devise_for :users , :controllers => {:registrations => "users/registrations"}
  resources :completed_orders
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get "/sign_up" => "users/registrations#new", as: "custom_user_registration" # custom path to sign_up/registration
  end
root "store#index"
 post "store/add_to_cart/:id", to: "store#add_to_cart", as: 'add_to_cart'
 post "store/delete_item/:id", to: "store#delete_item", as: 'delete_item'
 post "store/new_color_choice/:id", to: "store#new_color_choice", as: 'new_color_choice'
 post "store/edit_options/:id", to: "store#edit_options", as: 'edit_options'
 post "store/add_one/:id", to: "store#add_one", as: 'add_one'
 post "store/sub_one/:id", to: "store#sub_one", as: 'sub_one'
 post "store/shipping_info", to: "store#shipping_info", as: 'shipping_info'
 post "store/create", to: "store#create", as: 'store_create'
 get 'show', to: 'completed_orders#show', as: 'completed_orders_show'
 get 'contact', to: 'store#contact', as: 'contact'
 get 'about', to: 'store#about', as: 'about'
 get 'store/store_show/:id', to: 'store#store_show', as: 'store_show'
get 'products/delete_second/:id', to: 'products#delete_second' , as: 'delete_second'
 get 'cancel', to: 'store#cancel', as: 'store_cancel'
  get 'success', to: 'store#success', as: 'store_success'

  get "/store", to: "store#index"
  get "store/cart", as: 'cart'
  mount StripeEvent::Engine, at: '/stripe-webhooks'
  resources :webhooks, only: [:create]
  post "/webhook", to: "webhooks#create"

  post "completed_orders/mark/:id", to: "completed_orders#mark", as: 'mark'
  # Defines the root path route ("/")
  # root "articles#index"
end
