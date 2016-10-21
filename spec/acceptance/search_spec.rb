require_relative 'acceptance_helper'

feature 'Users can locate content by searching for', %q{
  In order to be able to find questions interested for me
  As an non-registered user
  I want to be able to search questions
} do

  given!(:user) { create :user, email: 'longtitle@example.com' }
  given!(:question) { create :question, title: 'longtitle question', content: 'longtitle question' }
  given!(:answer) { create :answer, content: 'longtitle answer' }
  given!(:comment) { create :comment, content: 'longtitle comment', commentable_id: question.id, commentable_type: 'Question' }  

  before do
    visit root_path
    fill_in 'q', with: 'longtitle'
  end

  scenario 'try to search all', sphinx: true do
    ThinkingSphinx::Test.run do
      select('Everywhere', from: 'a')
      click_on 'search_button'

      expect(current_path).to eq search_path

      expect(page).to have_content user.email
      expect(page).to have_content question.content
      expect(page).to have_content answer.content
      expect(page).to have_content comment.content
    end
  end

  scenario 'try to search question', sphinx: true do
    ThinkingSphinx::Test.run do
      select('Question', from: 'a')
      click_on 'search_button'

      expect(page).to have_content question.content
      expect(page).to_not have_content user.email
      expect(page).to_not have_content answer.content
      expect(page).to_not have_content comment.content
    end
  end

  scenario 'try to search answer', sphinx: true do
    ThinkingSphinx::Test.run do
      select('Answer', from: 'a')
      click_on 'search_button'

      expect(page).to have_content answer.content
      expect(page).to_not have_content user.email
      expect(page).to_not have_content question.content
      expect(page).to_not have_content comment.content
    end
  end

  scenario 'try to search comment', sphinx: true do
    ThinkingSphinx::Test.run do
      select('Comment', from: 'a')
      click_on 'search_button'

      expect(page).to have_content comment.content
      expect(page).to_not have_content user.email
      expect(page).to_not have_content question.content
      expect(page).to_not have_content answer.content
    end
  end

  scenario 'try to search user', sphinx: true do
    ThinkingSphinx::Test.run do
      select('User', from: 'a')
      click_on 'search_button'

      expect(page).to have_content user.email
      expect(page).to_not have_content question.content
      expect(page).to_not have_content answer.content
      expect(page).to_not have_content comment.content
    end
  end
end
