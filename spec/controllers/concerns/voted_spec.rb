require 'rails_helper'

RSpec.shared_examples 'voted' do |parameter|
  sign_in_user

  let(:user) { create :user }
  let!(:votable) { create(parameter.underscore.to_sym, user: user) }

  describe 'POST #like' do
    it 'vote count changed by 1' do
      expect { post :like, id: votable, format: :json }.to change(votable.votes, :count).by(1)
    end

    it 'vote value changed by 1' do
      post :like, id: votable, format: :json
      expect(votable.votes.last.value).to eq 1
    end
  end

  describe 'POST #dislike' do
    it 'vote count changed by 1' do
      expect { post :dislike, id: votable, format: :json }.to change(votable.votes, :count).by(1)
    end

    it 'vote value changed by 1' do
      post :dislike, id: votable, format: :json
      expect(votable.votes.last.value).to eq(-1)
    end
  end

  describe 'PATCH #change_vote' do
    it 'change like to dislike' do
      post :like, id: votable, format: :json
      patch :change_vote, id: votable, format: :json
      votable.reload

      expect(votable.votes.last.value).to eq(-1)
    end

    it 'change dislike to like' do
      post :dislike, id: votable, format: :json
      patch :change_vote, id: votable, format: :json
      votable.reload

      expect(votable.votes.last.value).to eq 1
    end
  end

  describe 'DELETE #cancel_vote' do
    before { post :dislike, id: votable, format: :json }

    it 'votable value changed' do
      delete :cancel_vote, id: votable, format: :json

      expect(votable.total).to eq 0
    end

    it 'entries in database changed' do
      expect { delete :cancel_vote, id: votable, format: :json }.to change(Vote, :count).by(-1)
    end
  end
end
