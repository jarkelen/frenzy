Frenzy::Application.routes.draw do
  resources :leagues
  resources :clubs
  resources :results
  resources :gamerounds
  resources :selections
  resources :jokers
  resources :scores, only: [:index] do
    post :calculate, on: :collection
  end

  get "site/index"
  get "users/index"
  get "users/show"
  get "frenzy/index"

  match '/sign_out' =>  "clearance/sessions#destroy"

  root to:'site#index'
end
