require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10).is_at_most(1000) }

  describe 'Check answer model methods' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: user }

    it '.switch_best toggle answer.best' do
      expect(answer.best).to eq false
      answer.switch_best
      expect(answer.best).to eq true
    end
  end
end
