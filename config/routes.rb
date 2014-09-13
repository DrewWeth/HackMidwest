Rails.application.routes.draw do
  resources :confirmations
  resources :alerts

  resources :events

  resources :groups

  devise_for :users

  resources :users

  
  # Home
  root to: "home#index"
  get 'home/about', to: 'home#about'

  # Groups
  get  'groups/leave/:id', to: 'groups#leave'
  post 'groups/join', to: 'groups#join'
  get  'home/alert', to: 'home#alert'

  # Confirmation
  match 'checkIn' => 'events#checkIn', :as => 'checkIn', via: [:get, :post]

  # Accounts
  post 'accounts/unsync', to: 'accounts#unsync'
  post 'accounts/remove_restrictions', to: 'accounts#remove_restrictions'

  post 'groups/remove/:id', to: 'groups#remove'

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
