Rails.application.routes.draw do
  root to: 'homepage#index'

  get '/typeahead_search', to: 'searches#typeahead_search'
  get '/search', to: 'searches#main_search'

  resources :episodes, only: [:show]
end
