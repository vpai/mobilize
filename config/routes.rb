Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get ':id', to: 'shortlinks#show'
  post '/links/new', to: 'shortlinks#new'
  
end
