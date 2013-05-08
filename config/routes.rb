Frenzy::Application.routes.draw do
  resources :leagues
  resources :periods
  resources :clubs
  resources :results do
    post :store_all,  on: :collection
    post :scrape,     on: :collection
  end
  resources :gamerounds
  resources :selections
  resources :jokers do
    post :store, on: :collection
  end
  resources :scores do
    collection do
      get :index
      post :index
    end
  end
  resources :rankings do
    collection do
      get :index
      post :index
    end
  end
  resources :newsitems do
    resources :comments
  end

  resources :users, only: [:index, :show, :destroy, :team]
  resources :profiles

  get  "frenzy/index"
  get  "frenzy/rules"
  post "frenzy/process_gameround"
  post "frenzy/switch_period"
  post "frenzy/switch_participation"
  post "frenzy/cancel_jokers"

  get "site/index"

  match '/sign_out' =>  "clearance/sessions#destroy"

  root to:'site#index'
end
