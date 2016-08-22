require 'rails_helper'

feature 'Create answer', '
  In order to get the advise for community member
  As an authenticated user
  I want to be able to add an answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }  

  scenario 'Authenticated user create question' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Content', with: 'Maybe 42?'
    click_on 'Add question'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)
    fill_in 'Content', with: 'Maybe 42?'
    click_on 'Add question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
