Rails.application.routes.draw do
  post 'login' => 'user_sessions#create', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
end
