require 'rails_helper'

feature 'Question show', '
  In order to find description for question
  As an non-authenticated user
  I want to be able to see the question content
' do

  given!(:user) { create :user }
  given!(:question) { create :question, user_id: user.id }
  given!(:answer) { create :answer, question: question, user_id: user.id }

  scenario 'Non-authenticated user want to show content' do
    visit questions_path
    click_on 'show'

    expect(page).to have_content 'Test title 1'
    expect(page).to have_content 'Forty two. That`s it. That`s all there is.'
  end
end
