require_relative 'acceptance_helper'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an answer`s author
  I`d like to be able to attach files
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Content', with: 'My answer with file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Content', with: 'My answer with file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'

    click_on 'Delete file'

    within '.answers' do
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'non owner not see delete_link'

  scenario 'User add several files when make asnwer', js: true do
    fill_in 'Content', with: 'My answer with file'
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
