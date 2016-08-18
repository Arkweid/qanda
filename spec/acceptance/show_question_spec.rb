require 'rails_helper'

feature 'Question show', '
  In order to find description for question
  As an non-authenticated user
  I want to be able to see the question content
' do

  given!(:question) { create(:question) }

  scenario 'Non-authenticated user want to show content' do
    visit questions_path
    click_on 'show'

    expect(page).to have_content 'Test content 1'
  end
end