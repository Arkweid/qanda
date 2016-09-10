require_relative 'acceptance_helper'

feature 'Best answer', '
  In order to show the most correct answer
  As an question owner
  I want to be able set best answer
' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer1) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try set the best answer' do
    visit question_path(question)

    within('.answers') do
      expect(page).to have_no_link 'Mark of best'
    end
  end

  scenario 'Non question owner try set the best answer' do
    sign_in(another_user)
    visit question_path(question)

    within('.answers') do
      expect(page).to have_no_link 'Mark of best'
    end
  end

  describe 'Question owner' do
    before { sign_in(user) }

    scenario 'see marked answer first', js: true do
      visit question_path(question)

      within("#answer-#{answer2.id}") do
        click_on 'Mark of best'
      end

      within('.answers') do
        expect(page).to have_css('.best-answer', count: 1)
        expect(page).to have_css("li#answer-#{answer2.id}.best-answer")
        expect(page.first(:css, 'li')[:class].include?('best-answer')).to eq true
      end
    end

    scenario 'unmark answer as best', js: true do
      answer2.update_attribute(:best, true)
      visit question_path(question)

      within("#answer-#{answer2.id}") do
        click_on 'Mark of best'
      end

      within('.answers') do
        expect(page).to have_css('.best-answer', count: 0)
      end
    end

    scenario 'change best answer', js: true do
      answer2.update_attributes(best: true)
      visit question_path(question)

      within("#answer-#{answer1.id}") do
        click_on 'Mark of best'
      end

      within('.answers') do
        expect(page).to have_css('.best-answer', count: 1)
        expect(page).to have_no_css("li#answer-#{answer2.id}.best-answer")
        expect(page).to have_css("li#answer-#{answer1.id}.best-answer")
      end
    end
  end
end
