Rails.application.routes.draw do
  root 'home#index'

  get '/auth/callback', to: 'auth#callback'
  get '/auth/connect',  to: 'auth#connect'
  delete '/logout',     to: 'auth#destroy'
  get '/logout',     to: 'auth#destroy'  
  get '/media', to: 'media#index'
end
