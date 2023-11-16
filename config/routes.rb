require 'sidekiq/web'
Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  
  mount Sidekiq::Web => '/sidekiq'
  
  draw :api
end
