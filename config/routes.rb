Rails.application.routes.draw do
  resources :prices
  resources :reports
  resources :settings
  resources :banners
  resources :favorites
  #mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  resources :likes
  resources :stores
  resources :comments
  resources :behaviors
  resources :categories
  resources :deals
  resources :descuentos, :controller => "deals"
  get '/_ah/health', to: 'app_engine#health'
  #get 'users', to: 'welcome#index'
  get 'welcome/index'
  root 'welcome#index'
  get 'image/scrapp', to: 'deals#scrapp'
  get 'amazon', to: 'deals#amazon'
  get 'amazonapi', to: 'deals#amazonapi'
  get 'validate/link', to: 'deals#validatelink'
  get 'updateRank', to: 'deals#rank'
  get 'saveComment', to: 'comments#saveComment'
  get 'moderatecomments', to: 'comments#moderate'
  get 'moderatescrappajax', to: 'deals#scrapromotionajax'
  get 'moderatescrapp', to: 'deals#scrapromotion'
  get 'moderatesusers', to: 'users#adminusers'
  get 'moderate', to: 'deals#moderate'
  get 'nosotros', to: 'welcome#nosotros'
  get 'nosotros', to: 'welcome#nosotros'
  get 'ayuda', to: 'welcome#ayuda'
  get 'terminos', to: 'welcome#terminos'
  get "mi-cuenta/:id" => "users#profile"
  get "mi-cuenta/mis-descuentos/" => "users#deals"
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
  get 'dealhit', to: 'deals#dealhit'
  get 'generatesitemap', to: 'deals#generateSitemap'
  get 'crawler', to: 'deals#crawler'
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
  get 'followers', to: 'users#followers'
  get 'followed', to: 'users#followed'
  get 'reportaction', to: 'reports#addreport'
  get 'bannersclick', to: 'banners#click'
  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create'
  get 'ofertas-de-temporada/:id', to: 'welcome#season'

  devise_for :users, :controllers => { sessions: 'users/sessions' ,:omniauth_callbacks => "users/omniauth_callbacks",  registrations: 'users/registrations' }
end