Frenzy::Application.routes.draw do
  resources :leagues
  resources :clubs
  resources :results
  resources :gamerounds


  root to:'site#index'
  get "site/index"

  get "users/index"
  get "users/show"

  match '/sign_out' =>  "clearance/sessions#destroy"
end
