Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  get '/help', to: 'pages#help'

  resources :cities, only: [:create, :destroy, :show] do
    collection do
      get 'refresh'
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :cities, only: [ :index ]
    end
  end
end
