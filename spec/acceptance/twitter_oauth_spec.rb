require_relative 'acceptance_helper'

feature 'User sign in via Twitter account', '
  In order to be able to ask question
  As an user
  I want to able to sign in via Twitter account
' do

  describe 'Access via Twitter account' do
    context 'Already registred' do
      given!(:user) { create :user, email: 'user@email.com' }

      scenario 'tries sign in via twitter' do
        visit new_user_session_path
        mock_auth_hash('twitter')
        click_on('Sign in with Twitter')

        expect(page).to have_content 'Successfully authenticated from Twitter account.'
        expect(page).to have_content 'user@email.com'
        expect(current_path).to eq root_path
      end
    end

    context 'Non-registred' do
      scenario 'tries sign in via twitter' do
        visit new_user_session_path
        mock_auth_hash('twitter')
        click_on('Sign in with Twitter')

        expect(page).to have_content 'Successfully authenticated from Twitter account.'
        expect(current_path).to eq root_path
      end
    end
  end
end
