Frenzy::Application.routes.draw do
  resources :leagues
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
  post "frenzy/process_gameround"

  get "site/index"

  match '/sign_out' =>  "clearance/sessions#destroy"

  root to:'site#index'
end
