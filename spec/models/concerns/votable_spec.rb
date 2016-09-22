require 'rails_helper'

RSpec.shared_examples 'votable' do
  let(:user) { create :user }
  let(:votable) { create(described_class.to_s.underscore.to_sym) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#set_evaluate' do
    it ':like' do
      expect { votable.set_evaluate(user, 1) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq 1
    end

    it ':dislike' do
      expect { votable.set_evaluate(user, -1) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq(-1)
    end
  end

  describe '#total' do
    it ':total' do
      votable.set_evaluate(user, 1)
      votable.set_evaluate(user, 1)
      votable.set_evaluate(user, -1)
      votable.set_evaluate(user, 1)
      votable.set_evaluate(user, 1)
      votable.set_evaluate(user, -1)

      expect(votable.total).to eq 2
    end
  end

  describe '#change_evaluate' do
    it ':change_evaluate' do
      votable.set_evaluate(user, 1)
      votable.change_evaluate(user)

      expect(votable.votes.last.value).to eq(-1)
    end
  end

  describe '#cancel_evaluate' do
    it ':cancel_evaluate' do
      votable.set_evaluate(user, 1)

      expect { votable.cancel_evaluate(user) }.to change(votable.votes, :count).by(-1)
    end
  end
end
