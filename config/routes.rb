Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  resources :likes
  resources :stores
  resources :comments
  resources :behaviors
  resources :categories
  resources :deals
  resources :descuentos, :controller => "deals"

  get 'welcome/index'
  root 'welcome#index'
  get 'image/scrapp', to: 'deals#scrapp'
  get 'validate/link', to: 'deals#validatelink'
  get 'updateRank', to: 'deals#rank'
  get 'saveComment', to: 'comments#saveComment'
  get 'moderate', to: 'deals#moderate'
  get "myprofile/:id" => "users#profile"
  get "descuentos-por-tienda/:id/:slug" => "deals#stores"
  get "descuentos-por-categoria/:id/:slug" => "deals#categories"
  get 'todas-las-categorias', to: 'categories#list'
  get 'todas-las-tiendas', to: 'stores#list'
  get 'nuevas', to: 'deals#newdeals'
  get 'top', to: 'deals#topdeals'
  get 'buscar-descuentos', to: 'deals#search'
  get 'likeComment', to: 'likes#add'
  get 'removeComment', to: 'likes#delete'

  devise_for :users, :controllers => { sessions: 'users/sessions' ,:omniauth_callbacks => "users/omniauth_callbacks",  registrations: 'users/registrations' }
end