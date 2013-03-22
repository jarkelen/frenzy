Frenzy::Application.routes.draw do
  resources :results


  root to:'site#index'
  get "site/index"

  get "users/index"
  get "users/show"

  match '/sign_out' =>  "clearance/sessions#destroy"
end
