require 'rails_helper'

RSpec.describe AnswerController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context "create with valid attributes" do
      it "saves a new answer for question to the database" do
        question
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end
    end
  end
end
