Rails.application.routes.draw do
  root "static_pages#start"
  devise_for :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
