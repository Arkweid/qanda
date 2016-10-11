require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user

  let(:question) { create :question, user: @user }
  let(:answer) { create :answer, question: question, user: @user }
  let(:invalid_answer) { create :invalid_answer, question: question }

  describe 'POST #create' do
    context 'answer with valid data' do
      it 'save new answer for question' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }
          .to change(question.answers, :count).by(1)
      end

      it 'new asnwer belongs_to to user' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }
          .to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'answer with invalid data' do
      it 'do not save new answer anywhere' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }
          .to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'Private_pub' do
      it 'recieve publish_to method' do
        expect(PrivatePub).to receive(:publish_to)

        post :create, answer: attributes_for(:answer), question_id: question, format: :js
      end
    end    
  end

  describe 'DELETE #destroy' do
    context 'User is owner' do
      before { answer }

      it 'delete answer from question' do
        expect { delete :destroy, id: answer, format: :js }
          .to change(question.answers, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not owner' do
      let(:another_user) { create(:user) }
      let!(:another_answer) { create :answer, question: question, user: another_user }

      it 'delete answer from question' do
        expect { delete :destroy, id: another_answer, format: :js }
          .to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, id: another_answer, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'User is owner' do
      it 'changes answer attribute' do
        patch :update, id: answer, answer: { content: 'new content' }, format: :js
        answer.reload
        expect(answer.content).to eq 'new content'
      end
    end

    context 'User not owner' do
      let(:another_user) { create(:user) }
      let!(:another_answer) { create :answer, question: question, user: another_user }

      it 'Not owner changes answer attribute' do
        patch :update, id: another_answer, answer: { content: 'new content' }, format: :js
        answer.reload
        expect(answer.content).to eq 'Forty two. That`s it. That`s all there is.'
      end
    end

    context 'Check assigns' do
      before { patch :update, id: answer, answer: attributes_for(:answer), format: :js }

      it 'assigns a requested answer to the variable @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    context 'Question owner' do
      before do
        patch :best, id: answer, format: :js
        answer.reload
      end

      it 'assigns the requested answer_id to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'set the best answer' do
        expect(answer.best).to eq true
      end

      it 'switch answer to not be best' do
        patch :best, id: answer, format: :js
        answer.reload

        expect(answer.best).to eq false
      end
    end

    context 'Not question owner' do
      let!(:another_user) { create(:user) }

      before do
        question.update_attribute(:user, another_user)
        patch :best, id: answer, format: :js
        answer.reload
      end

      it 'assigns the requested answer_id to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'try to set the best answer' do
        expect(answer.best).to eq false
      end
    end
  end

  it_behaves_like 'voted', 'answer'
end
