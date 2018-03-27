Rails.application.routes.draw do
  resources :users
  get 'auth' => 'auth#authorize'
  post 'user_token' => 'user_token#create'
  root 'auth#index'
end
