Rails.application.routes.draw do
  resources :stores
  resources :comments
  resources :behaviors
  resources :categories
  resources :descuentos, :controller => "deals"

  get 'welcome/index'
  root 'welcome#index'
  get 'image/scrapp', to: 'deals#scrapp'
  get 'validate/link', to: 'deals#validatelink'
  get 'updateRank', to: 'deals#rank'
  get 'moderate', to: 'deals#moderate'
  get "myprofile/:id" => "users#profile"
  get "descuentos-por-tienda/:id/:slug" => "deals#stores"
  get "descuentos-por-categoria/:id/:slug" => "deals#categories"

  devise_for :users, :controllers => { sessions: 'users/sessions' ,:omniauth_callbacks => "users/omniauth_callbacks",  registrations: 'users/registrations' }
end