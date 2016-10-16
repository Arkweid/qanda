require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }

  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'commentable'

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:content).is_at_least(5).is_at_most(1000) }

  context 'scope :from_yesterday' do
    let!(:old_question) { create :question, created_at: 2.days.ago }
    let!(:yesterday_question) { create :question, created_at: 1.days.ago }
    let!(:new_question) { create :question, created_at: Time.now }      

    it 'must contain question from yesterday' do
      expect(Question.from_yesterday.first).to eq yesterday_question
    end
  end
end
