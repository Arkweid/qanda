require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question, user: user }

  describe '#author_of?' do
    it 'user is author' do
      expect(user).to be_author_of(question)
    end

    it 'user non author' do
      expect(another_user).to_not be_author_of(question)
    end
  end

  describe '#voted?' do
    it 'user already voted' do
      question.set_evaluate(user, 1)

      expect(user).to be_voted(question)
    end

    it 'user not vote yet' do
      expect(user).to_not be_voted(question)
    end
  end

  describe '#can_vote?' do
    it 'author can`t vote' do
      expect(user).to_not be_can_vote(question)
    end

    it 'non author can vote' do
      expect(another_user).to be_can_vote(question)
    end
  end
end
