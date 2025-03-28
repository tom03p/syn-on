Rails.application.routes.draw do
  authenticated :user do
    root to: "cards#index", as: :user_root
  end
  unauthenticated do
    root to: "static_pages#start"
  end
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: "users/registrations"
  }
  namespace :account do
    resource :password, only: %i[edit update]
    resource :exit, only: %i[show destroy]
  end
  resources :cards, only: %i[index new create destroy]
  resource :profile, only: %i[show edit update]
  get "static_pages/setting"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
