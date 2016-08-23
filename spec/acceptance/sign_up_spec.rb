require 'rails_helper'

feature 'User can sign up', '
  In order to be new system user
  As a user
  I want to sign up
' do

  given(:user) { create(:user) }

  before { visit new_user_registration_path }

  scenario 'Non registred user try to sign in' do
    sign_up_new_user

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Sign up with already taken email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Sign up with blank params' do
    fill_in 'Email', with: nil
    fill_in 'Password', with: nil
    fill_in 'Password confirmation', with: nil
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Sign up with do not match password' do
    fill_in 'Email', with: 'example@exam.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '345'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end
end
