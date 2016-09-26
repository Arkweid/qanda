require_relative 'acceptance_helper'

feature 'Add vote to question', '
  In order to mark good question
  As an authenticated user
  I`d like to be able to vote for question
' do

  given(:user) { create :user }
  given(:another_user) { create :user }

  describe 'User voting' do
    context 'non author' do
      given(:question) { create :question, user: another_user }

      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'like question', js: true do
        click_on 'like'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'change vote'
        expect(page).to have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('1') }
      end

      scenario 'dislike question', js: true do
        click_on 'dislike'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'change vote'
        expect(page).to have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('-1') }
      end

      scenario 'change vote for question', js: true do
        click_on 'like'
        click_on 'change vote'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'change vote'
        expect(page).to have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('-1') }
      end

      scenario 'cancel vote for question', js: true do
        click_on 'like'
        click_on 'cancel vote'

        expect(page).to have_link 'like'
        expect(page).to have_link 'dislike'
        expect(page).to_not have_link 'change vote'
        expect(page).to_not have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('0') }
      end
    end

    context 'author' do
      given(:question) { create :question, user: user }

      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'not see links for vote' do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to_not have_link 'change vote'
        expect(page).to_not have_link 'cancel vote'
      end
    end
  end
end
