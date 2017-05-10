Rails.application.routes.draw do
  root 'home#index'
  get '/privacy', to: 'home#privacy'
end
