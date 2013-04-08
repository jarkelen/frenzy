module AuthenticationHelpers
  def sign_in_as(user)
    visit sign_in_path
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button 'Inloggen'
  end

  def sign_out
    Capybara.reset_sessions!
    visit destroy_user_session_url
  end
end
