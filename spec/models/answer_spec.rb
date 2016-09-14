require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10).is_at_most(1000) }

  it { should accept_nested_attributes_for :attachments}

  describe '#switch_best' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }
    let(:answer1) { create :answer, question: question }

    it 'default value false' do
      expect(answer.best).to eq false
    end

    it 'switch best value' do
      answer.switch_best

      expect(answer.best).to eq true
    end

    it 'old best must be false, when marked other' do
      answer.switch_best
      answer1.switch_best
      answer.reload

      expect(answer.best).to eq false
      expect(answer1.best).to eq true
    end
  end
end
