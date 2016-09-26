require_relative 'acceptance_helper'

feature 'Add comments to answers and questions', '
  In order to make clearer some thing
  As an authenticated user
  I want to be able make comments
' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question }

  describe 'authenticated user' do
    context 'User is owner' do
      before do
        sign_in(user)
        visit question_path(question)
        click_on 'New comment', match: :first
        fill_in 'comment_content', with: 'Looks like perpetuum mobile'
        click_on 'Add comment'
      end

      scenario 'add comment', js: true do
        expect(page).to have_content('Looks like perpetuum mobile')
        expect(page).to have_selector('textarea#comment_content', visible: false)
      end

      scenario 'edit comment', js: true do
        click_on 'Edit', match: :first
        fill_in 'comment_content', with: 'Its true perpetuum mobile'
        click_on 'Update comment'

        expect(page).to have_content('Its true perpetuum mobile')
        expect(page).to have_selector('textarea#comment_content', visible: false)
      end

      scenario 'edit comment with blank content', js: true do
        click_on 'Edit', match: :first
        fill_in 'comment_content', with: ''
        click_on 'Update comment'

        expect(page).to have_content("Content can't be blank")
      end

      scenario 'delete comment', js: true do
        click_on 'Delete comment'

        expect(page).to_not have_content('Looks like perpetuum mobile')
      end
    end

    context 'Non owner' do
      scenario 'non owner cant edit/delete comment', js: true do
        sign_in(another_user)
        visit question_path(question)

        expect(page).to_not have_link('Edit')
        expect(page).to_not have_link('Delete comment')
      end
    end
  end

  describe 'Guest' do
    before do
      visit question_path(question)
    end

    scenario 'not see comments functionality', js: true do
      expect(page).to_not have_link('New comment')
    end
  end
end
