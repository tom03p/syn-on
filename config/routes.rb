Rails.application.routes.draw do
  authenticated :user do
    root to: "cards#index", as: :user_root
  end
  unauthenticated do
    root to: "static_pages#start"
  end
  devise_for :users
  resources :cards, only: %i[index]
  resource :profile, only: %i[show edit update]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
