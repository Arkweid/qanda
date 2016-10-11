require 'rails_helper'

describe 'Questions API' do
  let(:options) { Hash.new }  

  describe 'GET #index' do
    let(:path) { '/api/v1/questions' }
   
    it_behaves_like "API Authenticable" 

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_pair :question }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title content created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id content created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create :question }
    let(:path) { "/api/v1/questions/#{question.id}" }
    
    it_behaves_like "API Authenticable"
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }
      
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }
      
      it 'returns 200 status code' do
        expect(response).to be_success
      end
    
      %w(id title content created_at updated_at).each do |attr|
        it "Question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
      
      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("question/short_title")
      end
      
      it_behaves_like "API Commentable", :question 
      it_behaves_like "API Attachable", :question
    end
  end

  describe 'POST #create' do
    let(:path) { "/api/v1/questions" }
    let(:options) { { question: attributes_for(:question) } }
    
    it_behaves_like "API Authenticable"
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      
      context 'with valid attributes' do
        it 'saves the new question in the database' do
         expect { post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }
          .to change(Question, :count).by(1)         
        end 
        
        it 'question belongs to user' do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(assigns(:question).user).to eq User.find(access_token.resource_owner_id)
        end
        
        it "returns question" do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          %w(id title content created_at updated_at).each do |attr|
            expect(response.body).to be_json_eql(Question.last.send(attr.to_sym).to_json).at_path("question/#{attr}")
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post '/api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
            .to_not change(Question, :count)
        end
        
        it 'returns error' do
          post '/api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token
          expect(response.body).to have_json_path("errors")
        end
      end  
    end
  end
end