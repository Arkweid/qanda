require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'render :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns to requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render :new template' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns to requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render :edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'create with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, question: attributes_for(:question) }
          .to change(Question, :count).by(1)
      end

      it 'redirects to :show template' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'create with invalid attributes' do
      it 'not to save a new question to the database' do
        expect { post :create, question: attributes_for(:invalid_question) }
          .to_not change(Question, :count)
      end

      it 'redirects to :new template' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'update with valid attributes' do
      it 'assigns a requested question to the variable @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes attributes question' do
        patch :update, id: question, question: { title: 'new title', content: 'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.content).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'to_not change attributes' do
        patch :update, id: question, question: { title: 'new title', content: nil }
        expect(question.title).to eq 'Test title 32'
        expect(question.content).to eq 'Test content 32'
      end

      it 'render :edit template' do
        patch :update, id: question, question: attributes_for(:invalid_question)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    
    context 'user is question owner' do
      before { question.update_attribute(:user_id, @user.id) }

      it 'delete own question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end    

      it 'redirects to :index template' do
        delete :destroy, id: question    
        expect(response).to redirect_to questions_path
      end
    end

     context 'user is not question owner' do
      before { question.update_attribute(:user_id, nil) }
        
      it 'delete own question' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end    

      it 'redirects to :index template' do
        delete :destroy, id: question    
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
