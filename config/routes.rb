Frenzy::Application.routes.draw do
  root to:'site#index'
  get "site/index"

  match '/sign_out' =>  "clearance/sessions#destroy"
end
