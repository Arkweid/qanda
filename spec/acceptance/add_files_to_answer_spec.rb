require_relative 'acceptance_helper'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an answer`s author
  I`d like to be able to attach files
' do

  given(:user) { create :user }
  given(:question) { create :question }

  describe 'Owner user try' do
    before do
      sign_in(user)
      visit question_path(question)
      fill_in 'Content', with: 'My answer with file'
    end

    scenario 'add file to answer', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add answer'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'delete file from answer', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add answer'

      click_on 'Delete file'

      within '.answers' do
        expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'add several files when make asnwer', js: true do
      click_on 'add file'

      within(all(:css, '.nested-fields').first) do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end
      within(all(:css, '.nested-fields').last) do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on 'Add answer'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end
  end

  describe 'Non owner' do
    given(:another_user) { create :user }
    given(:answer) { create(:answer, question: question, user: another_user) }
    given!(:answer_file) { create(:attachment, attachable: answer) }

    scenario 'not to see delete file link' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
end
