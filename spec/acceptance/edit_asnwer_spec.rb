require_relative 'acceptance_helper'

feature 'Answer editing', '
  In order to fix mistake
  As a author of answer
  I want to be able edit my answer
' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Answer owner' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'edit his answer', js: true do
      within('.answers') do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.content
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit files for answer', js: true do
      within('.answers') do
        click_on 'Edit'
        click_on 'add file'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end
  end

  scenario 'Non-author don`t see link to edit' do
    sign_in another_user

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Non-authenticated guest don`t see link to edit' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
