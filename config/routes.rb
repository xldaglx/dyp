Rails.application.routes.draw do
  resources :favorites
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
  get 'moderatecomments', to: 'comments#moderate'
  get 'moderate', to: 'deals#moderate'
  get 'nosotros', to: 'welcome#nosotros'
  get 'contacto', to: 'welcome#contacto'
  get 'ayuda', to: 'welcome#ayuda'
  get 'terminos-condiciones', to: 'welcome#terminos-condiciones'
  get "mi-cuenta/:id" => "users#profile"
  get "mi-cuenta/mis-descuentos/:id" => "users#deals"
  get "mi-cuenta/mis-favoritas/:id" => "users#favorites"
  get "mi-cuenta/mis-votadas/:id" => "users#rated"
  get "mi-cuenta/mi-ranking/:id" => "users#ranking"
  get "perfil-publico/:id" => "users#publicprofile"
  get "descuentos-por-tienda/:id/:slug" => "deals#stores"
  get "descuentos-por-categoria/:id/:slug" => "deals#categories"
  get 'todas-las-categorias', to: 'categories#list'
  get 'todas-las-tiendas', to: 'stores#list'
  get 'nuevas', to: 'deals#newdeals'
  get 'top', to: 'deals#topdeals'
  get 'dealaction', to: 'deals#updateStatus'
  get 'commentaction', to: 'comments#updateStatus'
  get 'buscar-descuentos', to: 'deals#search'
  get 'likeComment', to: 'likes#add'
  get 'addtofavorites', to: 'favorites#create'
  get 'removefromfavorites', to: 'favorites#delete'
  get 'removeComment', to: 'likes#delete'
  get 'cranking', to: 'users#cranking'
  get 'ranking', to: 'users#ranking'
  get 'follow', to: 'users#follow'
  get 'unfollow', to: 'users#unfollow'

  devise_for :users, :controllers => { sessions: 'users/sessions' ,:omniauth_callbacks => "users/omniauth_callbacks",  registrations: 'users/registrations' }
end