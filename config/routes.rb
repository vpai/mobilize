Rails.application.routes.draw do

  # Main application routes.
  get '/:hash', to: 'shortlinks#redirect'
  get '/stats/:hash', to: 'shortlinks#stats'

  # Create new short link.
  post '/links/new', to: 'shortlinks#new'

end
