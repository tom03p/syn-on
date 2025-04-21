require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user, confirmed_at: Time.current) }

  describe "サインイン前" do
    context "フォームの入力値が登録可の状態" do
      it "サインイン処理が成功する" do
        visit user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'サインイン'
        expect(page).to have_content 'サインインしました。'
        expect(page).to have_current_path(user_root_path, wait: 1)
      end
    end
    context "フォームの入力値が登録不可の状態" do
      it "フォームが未入力でサインイン処理が失敗する" do
        visit user_session_path
        click_button 'サインイン'
        expect(page).to have_content 'メールアドレス 又はパスワードが無効です。'
        expect(page).to have_current_path(user_session_path, wait: 1)
      end
    end
  end

  describe "サインイン後" do
    context "サインアウト" do
      it "サインアウトボタンをクリックするとサインアウトされる" do
        signin_as(user)
        find('.hamburger-menu').click
        click_link 'サインアウト'
        expect(page).to have_content 'サインアウトしました。'
        expect(page).to have_current_path(root_path, wait: 1)
      end
    end
  end
end
