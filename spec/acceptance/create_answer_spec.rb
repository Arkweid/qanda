require_relative 'acceptance_helper'

feature 'Create answer', '
  In order to get the advise for community member
  As an authenticated user
  I want to be able to add an answer
' do

  given(:user) { create :user }
  given(:question) { create :question, user: user }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)    
    end

    scenario 'Authenticated user add answer', js: true do
      fill_in 'Content', with: 'Maybe its 42?'
      click_on 'Add answer'

      within '.answers' do
        expect(page).to have_content 'Maybe its 42?'
      end
    end

    scenario 'Authenticated user try add invalid answer', js: true do
      click_on 'Add answer'

      expect(page).to have_content 'Content is too short'
    end    
  end

  scenario 'Non-authenticated user add answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Add answer'
  end
end
