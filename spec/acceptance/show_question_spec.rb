require_relative 'acceptance_helper'

feature 'Question show', '
  In order to find description for question
  As an non-authenticated user
  I want to be able to see the question content
' do

  given!(:user) { create :user }
  given!(:question) { create :question, user: user }

  scenario 'Non-authenticated user want to show content' do
    visit questions_path
    click_on 'show'

    expect(page).to have_content question.title
    expect(page).to have_content question.content
  end
end
