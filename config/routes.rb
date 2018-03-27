Rails.application.routes.draw do
  resources :users
  get 'auth' => 'auth#authorized'
  root 'auth#index'
  # Get sign token from Knock
  post 'user_token' => 'user_token#create'
end
