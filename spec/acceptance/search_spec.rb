#require_relative 'acceptance_helper'
require_relative 'acceptance_thinking_sphinx_helper'

feature 'Users can locate content by searching for', %q{
  In order to be able to find questions interested for me
  As an non-registered user
  I want to be able to search questions
} do

  given!(:question) { create :question, title: 'longtitle', content: 'longcontent' }

  describe 'Non-registered user' do
    scenario 'try to search question', sphinx: true do
      visit root_path
      fill_in 'q', with: 'longtitle'
      select('Question', from: 'a')
      click_on 'search_button'
      save_and_open_page

      expect(current_path).to eq search_path
      expect(page).to have_content question.content
    end
  end
end