Rails.application.routes.draw do
  root 'home#index'
  get '/privacy', to: 'home#privacy'
  get '/auth/callback', to: 'auth#callback'
  get '/auth/connect', to: 'auth#connect'
end
