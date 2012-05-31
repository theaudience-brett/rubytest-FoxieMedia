Foxiemedia::Application.routes.draw do
  get "sessions/new"

  match "configs/update" => 'configs#update'
  match "configs/:sect" => 'configs#index'
  resources :configs

  get "register" => 'users#register', :as => :register

  post "register" => 'users#create'
  resources :users

  resources :sessions, :only => [:new, :create, :destroy]

  match "login" => 'sessions#new', :as => :login

  match "logout" => 'sessions#destroy', :as => :logout

  resources :show_artworks

  resources :episodes

  get "shows/populate"

  get "shows/find"
  post "shows/find_results"

  match "shows/find/:name" => 'shows#find_results'

  match "shows/:id/populate" => 'shows#populate', :as => :populate

  match "shows/:id/userconfig" => 'shows#userconfig', :as => :showconfig

  match "shows/:id/cover/:show_artwork_id" => 'shows#setcover', :as => :setcover

  resources :shows

  root :to => 'shows#index', :as => 'shows'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
