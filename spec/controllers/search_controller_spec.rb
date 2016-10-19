require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    it 'ThinkingSphinx search' do
      expect(ThinkingSphinx).to receive(:search).and_call_original
      get :index, a: 'Question', q: 'exampletest'
    end
  end
end