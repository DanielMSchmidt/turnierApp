TurnierList::Application.routes.draw do

  get "membership/create"
  put "/membership/verify/:user_id/:club_id" => "membership#verify", as: :verify_user
  get "membership/destroy"

  resources :clubs

  resources :tournaments
  match "/tournament/:id/enroll" => "tournaments#set_as_enrolled", as: :just_enrolled
  match "/user/:id/tournaments" => "tournaments#of_user", as: :user_tournaments
  match "/membership/new/:user_id/:club_id" => "membership#create", as: :add_club
  match "/membership/delete/:user_id/:club_id" => "membership#destroy", as: :delete_club
  match "/impressum" => "home#impressum"
  match "/club/:club_id/transfer/:user_id" => "clubs#transfer_ownership", as: :transfer_ownership_to

  devise_for :users

  root :to => "home#index"


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
