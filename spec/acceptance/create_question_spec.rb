require 'rails_helper'

feature 'Create question', '
  In order to get the answer from community
  As an authenticated user
  I want to be able to ask a question
' do

  given(:user) { create :user }

  context 'User already registred' do
    before { sign_in(user) }

    scenario 'his create question' do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Some question'
      fill_in 'Content', with: 'Some text'
      click_on 'Create'

      expect(page).to have_content 'Your question successfully created.'
    end

    scenario 'his try create empty question' do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_on 'Create'

      expect(page).to have_content "Content can't be blank"
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'his try create short question' do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: '1'
      fill_in 'Content', with: '1'
      click_on 'Create'

      expect(page).to have_content 'Content is too short (minimum is 5 characters)'
      expect(page).to have_content 'Title is too short (minimum is 5 characters)'
    end
  end

  context 'User non-registred' do
    scenario 'Non-authenticated user create question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
