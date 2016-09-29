require_relative 'acceptance_helper'

feature 'User can delete his message', '
In order to delete my question
As a user
I want to delete my question
' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question, user: user }

  scenario 'Owner delete his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to_not have_content 'Test title'
    expect(current_path).to eq questions_path
  end

  scenario 'Not owner try to delete question' do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Non registred user try to delete message' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
