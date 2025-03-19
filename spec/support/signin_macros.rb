module SigninMacros
  def signin_as(user)
    visit user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'サインイン'
  end
end
