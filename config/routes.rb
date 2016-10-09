Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: "questions#index"

  concern :votable do
    member do
      post :like
      post :dislike
      patch :change_vote
      delete :cancel_vote
    end
  end

  resources :questions, shallow: true, concerns: :votable do
    resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable_type: 'question' }
    resources :answers, shallow: true, concerns: :votable do
      resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable_type: 'answer' }
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  get 'terms_and_conditions', to: 'user_agreements#terms_and_conditions'
  get 'policies', to: 'user_agreements#policies'

  devise_scope :user do
    post '/twitter', to: 'omniauth_callbacks#twitter'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end
end
