Rails.application.routes.draw do


devise_for :admins, controllers: {
  sessions:      'admins/sessions',
  passwords:     'admins/passwords',
  registrations: 'admins/registrations'
}
  devise_for :customers, controllers: {
  sessions:      'customers/sessions',
  passwords:     'customers/passwords',
  registrations: 'customers/registrations'
}

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:index, :show, :update]
    resources :order_items, only: [:update]
    resources :items, only: [:index, :new, :create, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    get "search" => "searches#search"
  end

  scope module: :customers do
    resources :customers, only: [:show, :edit, :update]
    get 'customers/:id/destroy_confirm' => 'customers#destroy_confirm', as: :destroy_confirm
    patch 'customers/:id/withdraw' => 'customers#withdraw', as: :withdraw
    post 'orders/confirm' => 'orders#confirm'
    get 'orders/confirm' => 'orders#new'
    get 'orders/complete' => 'orders#complete', as: :orders_complete
    resources :orders, only: [:index, :show, :new, :create]
    resources :items, only: [:index, :show]
    resources :cart_items, only: [:index, :update, :create, :destroy]
    delete 'cart_items' => 'cart_items#all_destroy', as: :all_destroy
    resources :deliveries, only: [:index, :create, :destroy, :edit, :update]

    root to: 'homes#top'
    get 'about' => 'homes#about'
 end

end
