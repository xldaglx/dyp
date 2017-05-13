Rails.application.routes.draw do
  resources :comments
  resources :behaviors
  resources :categories
  resources :deals
  get 'welcome/index'
  root 'welcome#index'
  get 'image/scrapp', to: 'deals#scrapp'
  get 'updateRank', to: 'deals#rank'
  get 'moderate', to: 'deals#moderate'
  devise_for :users, :controllers => { sessions: 'users/sessions' ,:omniauth_callbacks => "users/omniauth_callbacks",  registrations: 'users/registrations' }
end