require 'rails_helper'

RSpec.shared_examples 'voted' do |parameter|
  sign_in_user

  let(:user) { create :user }
  let!(:votable) { create(parameter.underscore.to_sym, user: user) }

  describe 'POST #like' do
    context 'non author vote' do
      it 'vote count changed by 1' do
        expect { post :like, id: votable, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'vote value changed by 1' do
        post :like, id: votable, format: :json
        expect(votable.votes.last.value).to eq 1
      end      
    end
  end
end
