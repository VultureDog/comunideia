Comunideia::Application.routes.draw do
  
  root :to =>'home#home'

  
  match '/signup', to: 'users#signup', via: 'get'
  match '/signup', to: 'users#create', via: 'post'
  match '/signin',  to: 'home#home',      via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  match '/', to: 'sessions#create', via: 'post'
  match '/sessions', to: 'sessions#create', via: 'get'

  resources :users
  resources :sessions, only: [:create, :destroy]
  resources :ideas
  resources :recompenses, only: [:create, :edit, :update, :destroy]
  resources :investments, only: [:show, :create]

  match '/get_token_oauth', to: 'images_videos#get_token_oauth', via: 'get'
  match '/callback_token', to: 'images_videos#callback_token', via: 'get'
  match '/upload_image', to: 'images_videos#upload_image', via: 'post'

  get '/auth/:provider/callback' => 'sessions#create', as: :auth_callback
  get '/auth/failure' => 'sessions#failure', as: :auth_failure


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
