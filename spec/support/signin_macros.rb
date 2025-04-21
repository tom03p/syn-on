module SigninMacros
  def signin_as(user)
    visit user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'サインイン'
    expect(page).to have_content 'サインインしました。'
    expect(page).to have_current_path(user_root_path, wait: 1)
  end
end
