require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user

  let(:user) { create :user }
  let(:question) { create :question, user_id: user.id }
  let(:answer) { create :answer, question: question, user_id: user.id }
  let(:invalid_answer) { create :invalid_answer, question: question }

  describe 'POST #create' do
    context 'answer with valid data' do
      it 'save new answer for question' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }
          .to change(question.answers, :count).by(1)
      end

      it 'redirect to question#show' do
        post :create, answer: attributes_for(:answer), question_id: question 
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'answer with invalid data' do
      it 'do not save new answer anywhere' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }
          .to_not change(Answer, :count)
      end

      it 'render question#show' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
