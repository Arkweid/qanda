require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:user_question) { create :question, user: user }
    let(:other_question) { create :question, user: other }
    let(:user_answer) { create :answer, user: user }
    let(:other_answer) { create :answer, user: other }
    let(:user_comment) { create :comment, user: user }
    let(:other_comment) { create :comment, user: other }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Attachment }
    end

    context 'update' do
      it { should be_able_to :update, user_question, user: user }
      it { should_not be_able_to :update, other_question, user: user }

      it { should be_able_to :update, user_answer, user: user }
      it { should_not be_able_to :update, other_answer, user: user }

      it { should be_able_to :update, user_comment, user: user }
      it { should_not be_able_to :update, other_comment, user: user }
    end

    context 'destroy' do
      it { should be_able_to :destroy, user_question, user: user }
      it { should_not be_able_to :destroy, other_question, user: user }

      it { should be_able_to :destroy, user_answer, user: user }
      it { should_not be_able_to :destroy, other_answer, user: user }

      it { should be_able_to :destroy, user_comment, user: user }
      it { should_not be_able_to :destroy, other_comment, user: user }

      it { should be_able_to :destroy, create(:attachment, attachable: user_question), user: user }
      it { should_not be_able_to :destroy, create(:attachment, attachable: other_question), user: user }
    end

    context 'subscribe' do
      it { should be_able_to :subscribe, Question }
      it { should be_able_to :unsubscribe, Question }
    end

    let(:user_subject) { user_question }
    let(:other_subject) { other_question }
    it_behaves_like 'Access to vote'

    let(:user_subject) { user_answer }
    let(:other_subject) { other_answer }
    it_behaves_like 'Access to vote'
  end
end
