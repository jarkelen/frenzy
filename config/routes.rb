Frenzy::Application.routes.draw do
  resources :leagues
  resources :periods
  resources :clubs
  resources :results do
    post :store_all, on: :collection
  end
  resources :gamerounds
  resources :selections
  resources :jokers do
    post :store, on: :collection
  end
  resources :scores, only: [:index]
  resources :rankings, only: [:index]
  resources :users, only: [:index, :show, :team]

  get  "frenzy/index"
  get  "frenzy/rules"
  post "frenzy/process_gameround"
  post "frenzy/cancel_jokers"

  get "site/index"

  match '/sign_out' =>  "clearance/sessions#destroy"

  root to:'site#index'
end
