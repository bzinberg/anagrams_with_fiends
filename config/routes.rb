BzinbergJiangtydYczLapentabFinal::Application.routes.draw do
  get "lobby/status", as: 'lobby_status'
  post "lobby/accrej", as: 'accrej'
  post "lobby/challenge", as: 'challenge'
  post "lobby/withdraw", as: 'withdraw'
  resources :users
  # resources :tables
  get "table" => "tables#show_table", as: "show_table"
  # get "forcenewtable" => "tables#force_new_table", as: "force_new_table"
  post "flip" => "tables#flip", as: "flip"
  get "quitsingleplayer" => "tables#quit_single_player", as: "quit_single_player"
  get "forfeit" => "tables#forfeit", as: "forfeit"
  get "clearfinishedtable" => "tables#clear_finished_table", as: "clear_finished_table"

  # get '/mytable', to: 'tables#show_my_table'
  resources :sessions, except: [:new]
  root to: 'home#index'
  get "sessions/new"
  
  get "log_out" => "sessions#destroy", as: "log_out"
  get "log_in" => "sessions#new", as: "log_in"
  get "sign_up" => "users#new", as: "sign_up"
  get "leaderboard" => "leaderboard#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
