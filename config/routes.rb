Rails.application.routes.draw do
# 顧客用
# URL /customers/sign_in ...
devise_for :customers, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

namespace :admin do
    resources :orders, only: [:show, :update]
    get "/" => "homes#top"
    resources :customers, only: [:index, :show, :edit, :update]
    
    resources :items, only: [:index, :create, :new, :show, :edit, :update]
    resources :order_details, only: [:update]
    get "/search" => "items#search"
  end

scope module: :public do
    get "/customers/check" => "customers#check"
    patch "/customers/withdraw" => "customers#withdraw"
    resource :customers, only: [:show, :update, :edit]
    post "/orders/check" => "orders#check"
    get "/orders/thanks" => "orders#thanks"
    resources :orders, only: [:new, :create, :show, :index,]
    delete "/cart_items/destroy_all" => "cart_items#destroy_all"
    resources :cart_items, only: [:index, :create, :destroy, :update]
    resources :items, only: [:index, :show]
    root "homes#top"
    get "/about" => "homes#about"
    get "/search" => "items#search"
  end

end
