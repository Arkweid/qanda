require 'rails_helper'

feature 'User can delete his message', '
In order to delete my question
As a user
I want to delete my question
' do
  
  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'Owner delete his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted.'
    expect(current_path).to eq questions_path
  end
end