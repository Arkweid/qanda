require 'rails_helper'

feature 'User sign in', '
  In order to be able to ask question
  As an user
  I want to be able to sign on
' do

  given(:user) { create(:user) }

  scenario 'Registred user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registred user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'example@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password. Log in Email Password Remember me Sign up Forgot your password?'
    expect(current_path).to eq new_user_session_path
  end
end