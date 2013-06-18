Frenzy::Application.routes.draw do
  resources :leagues, except: [:show]
  resources :periods, except: [:new]
  resources :clubs do
    collection do
      get :index
      post :index
    end
  end
  resources :newsitems do
    resources :comments
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy]

  namespace :clubs_frenzy do

  end

  resources :results do
    collection do
      post :store_all
      post :scrape
      get :index
      post :index
    end
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
      get :period
      get :general
    end
  end


  get  "frenzy/index"
  get  "frenzy/rules"
  get  "frenzy/about"
  post "frenzy/process_gameround"
  post "frenzy/switch_period"
  post "frenzy/switch_participation"
  post "frenzy/cancel_jokers"

  get "site/index"

  match '/sign_out', to:  "clearance/sessions#destroy"

  match "/404", to: "errors#not_found"
  match "/403", to: "errors#not_authorized"
  match "/500", to: "errors#internal_server_error"

  root to:'site#index'
end
