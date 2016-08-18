require 'rails_helper'

feature 'Questions index', '
  In order to find some other questions
  As an non-authenticated user
  I want to be able to see the questions index
' do

  given!(:question) { create_list(:question, 10) }

  scenario 'Non-authenticated user visit qustions#index' do
    visit questions_path

    expect(page).to have_content 'Test title 10'
  end
end