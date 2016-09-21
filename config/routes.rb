Rails.application.routes.draw do
  devise_for :users
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
    resources :answers, shallow: true, concerns: :votable do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
end
