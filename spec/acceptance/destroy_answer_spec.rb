require_relative 'acceptance_helper'

feature 'User can delete his message', '
In order to delete my question
As a user
I want to delete my question
' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  scenario 'Owner try to delete answer' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content 'Forty two. That`s it. That`s all there is.'

    click_on 'Delete answer'
    expect(page).to_not have_content 'Forty two. That`s it. That`s all there is.'
  end

  scenario 'Not owner try to delete answer' do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to have_content 'Forty two. That`s it. That`s all there is.'
    expect(page).to_not have_content 'Delete question'
  end
end
