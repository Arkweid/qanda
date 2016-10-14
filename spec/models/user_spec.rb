require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe 'subscriptions methods' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }

    context '.subscribe_to' do
      it 'make new record' do
        expect { user.subscribe_to(question) }.to change(Subscription, :count).by(1)
      end

      it 'should subscribe user to question' do
        expect { user.subscribe_to(question) }.to change(user.subscriptions, :count).by(1)
      end

      it 'subscribe only once' do
        user.subscribe_to(question)
        user.subscribe_to(question)

        expect(user.subscriptions.size).to eq 1
      end
    end

    context '.unsubscribe_from' do
      it 'unsubscribe user from question' do
        user.subscribe_to(question)
        expect { user.unsubscribe_from(question) }.to change(user.subscriptions, :count).by(-1)
      end

      it 'delete nothing if user not subscribed' do
        expect { user.unsubscribe_from(question) }.to_not change(Subscription, :count)
      end
    end

    context '.subscribe?' do
      it 'return true if user subscribed' do
        user.subscribe_to(question)
        expect(user.subscribed?(question)).to eq true
      end

      it 'return true if user subscribed' do
        expect(user.subscribed?(question)).to eq false
      end
    end
  end
end
