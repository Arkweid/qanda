require_relative 'acceptance_helper'

feature 'User sign in via Facebook account', '
  In order to be able to ask question
  As an user
  I want to able to sign in via Facebook account
' do

  describe 'Access via Facebook account' do
    context 'Already registred' do
      given!(:user) { create :user, email: 'user@email.com' }

      scenario 'tries sign in via facebook' do
        visit new_user_session_path
        mock_auth_hash('facebook')
        click_on('Sign in with Facebook')

        expect(page).to have_content 'Successfully authenticated from Facebook account.'
        expect(page).to have_content 'user@email.com'
        expect(current_path).to eq root_path
      end
    end

    context 'Non-registred' do
      scenario 'tries sign in via facebook' do
        visit new_user_session_path
        mock_auth_hash('facebook')
        click_on('Sign in with Facebook')

        expect(page).to have_content 'Successfully authenticated from Facebook account.'
        expect(current_path).to eq root_path
      end
    end
  end
end
