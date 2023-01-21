Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'homes#top'
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#guest_sign_in'
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => 'relationships#followings'
    get "followers" => 'relationships#followers'
  end

  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :tags, only: [:index] do
    get 'search' => 'searches#tag_search'
  end

  get 'favorites' => 'favorites#index'
  get 'user_search' => 'searches#user_search'
  get 'post_search' => 'searches#post_search'

  get 'about' => 'homes#about'
  get 'timeline' => 'posts#timeline'
end
