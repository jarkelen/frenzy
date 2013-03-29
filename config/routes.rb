Frenzy::Application.routes.draw do
  resources :leagues
  resources :clubs
  resources :results
  resources :gamerounds
  resources :selections
  resources :jokers do
    post :store, on: :collection
  end
  resources :scores, only: [:index]
  resources :rankings, only: [:index]
  resources :users

  get  "frenzy/index"
  post "frenzy/process_gameround"

  get "site/index"

  match '/sign_out' =>  "clearance/sessions#destroy"

  root to:'site#index'
end
