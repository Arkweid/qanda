module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up_new_user
    visit new_user_registration_path

    fill_in 'Email', with: 'example@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
  end

  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new('provider' => provider,
                                                                        'uid' => '123545',
                                                                        'info' => {
                                                                          'name' => 'mockuser',
                                                                          'email' => 'user@email.com'
                                                                        },
                                                                        'credentials' => {
                                                                          'token' => 'mock_token',
                                                                          'secret' => 'mock_secret'
                                                                        })
  end
end
