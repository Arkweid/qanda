require 'rails_helper'

feature 'User can delete his message', '
In order to delete my question
As a user
I want to delete my question
' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question, user_id: user.id }

  scenario 'Owner delete his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted.'
    expect(current_path).to eq questions_path
  end

  scenario 'Not owner delete try to question' do
    sign_in(another_user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'You not owner of this question'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non registred user try to delete message' do
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end  
end