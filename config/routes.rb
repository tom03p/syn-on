Rails.application.routes.draw do
  root "static_pages#start"
  devise_for :users
  
end
