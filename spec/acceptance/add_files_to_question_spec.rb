require_relative 'acceptance_helper'

feature 'Add files to question', '
  In order to illustrate my question
  As an question`s author
  I`d like to be able to attach files
' do

  given(:user) { create :user }

  describe 'User try' do
    before do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Content', with: 'text text text'
    end

    scenario 'add file when asks question' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    end

    scenario 'add several files when asks question', js: true do
      click_on 'add file'

      within(all(:css, '.nested-fields').first) do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end
      within(all(:css, '.nested-fields').last) do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/4/rails_helper.rb'
    end
  end

  describe 'Non owner' do
    given(:another_user) { create :user }
    given(:question) { create(:question, user: another_user) }
    given!(:question_file) { create(:attachment, attachable: question) }

    scenario 'not to see delete file link' do
      expect(page).to_not have_link 'Delete file'
    end
  end
end
