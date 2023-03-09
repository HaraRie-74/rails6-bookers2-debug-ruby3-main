Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to:"homes#top"
  get "home/about"=>"homes#about"
  get "search"=>"searches#search"

  # ↓DMのやつ
  resources :chats,only:[:show,:create]

  # グループのやつ　exceptは「～を除く」という意味
  resources :groups,except:[:destroy]

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create,:destroy]
    resources :book_comments,only: [:create,:destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :following, :followers
    end
    resource :relationships,only: [:create,:destroy]
    get "searchshow",to:"users#searchshow"
    # ユーザーshowページの検索機能
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end