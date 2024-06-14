Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  get 'home/suggest', to: 'home#suggest'


  resources :posts do
    resources :likes, only: [:create, :destroy]
    get 'replay', to: 'posts#replay', as: 'replay'
    post 'replay', to: 'posts#replay_create', as: 'replay_create'
    get 'repost', to: 'posts#repost', as: 'repost'
  end

  resources :profile
  post 'profile/follow', to: 'profile#follow'
  post 'profile/unfollow', to: 'profile#unfollow'
end
