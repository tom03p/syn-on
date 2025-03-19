require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe 'サインイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が登録可の状態' do
        it 'ユーザーの新規登録が成功する' do
          visit new_user_registration_path
          fill_in 'メールアドレス', with: 'tester@mail.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'Welcome! あなたのアカウントは正常にサインアップされました。'
          expect(page).to have_current_path(user_root_path, wait: 1)
        end
      end
      context 'フォームの入力値が登録不可の状態' do
        it 'メールアドレスが空でユーザーの新規登録が失敗する' do
          visit new_user_registration_path
          fill_in 'メールアドレス', with: nil
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
          expect(page).to have_current_path(new_user_registration_path, wait: 1)
        end
        it 'パスワードが確認パスワードと異なるとユーザーの新規登録が失敗する' do
          visit new_user_registration_path
          fill_in 'メールアドレス', with: 'tester@mail.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: nil
          click_button '登録'
          expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          expect(page).to have_current_path(new_user_registration_path, wait: 1)
        end
        it 'パスワードが空でユーザーの新規登録が失敗する' do
          visit new_user_registration_path
          fill_in 'メールアドレス', with: 'tester@mail.com'
          fill_in 'パスワード', with: nil
          fill_in 'パスワード確認', with: nil
          click_button '登録'
          expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
          expect(page).to have_content 'パスワードを入力してください'
          expect(page).to have_current_path(new_user_registration_path, wait: 1)
        end
        it '登録済みのメールアドレスを使用するとユーザーの新規登録が失敗する' do
          user1 = create(:user)
          visit new_user_registration_path
          fill_in 'メールアドレス', with: user1.email
          fill_in 'パスワード', with: user1.password
          fill_in 'パスワード確認', with: user1.password_confirmation
          click_button '登録'
          expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(page).to have_current_path(new_user_registration_path, wait: 1)
        end
      end
    end
    describe 'サインイン前のページ遷移' do
      it 'プロフィールへのアクセスが失敗する' do
        visit profile_path
        expect(page).to have_content 'この操作を続けるには新規登録又はサインインしてください。'
        expect(page).to have_current_path(user_session_path, wait: 1)
      end
      it 'カードの新規作成ページへのアクセスが失敗する' do
        visit new_card_path
        expect(page).to have_content 'この操作を続けるには新規登録又はサインインしてください。'
        expect(page).to have_current_path(user_session_path, wait: 1)
      end
    end
  end

  describe 'サインイン後' do
    before { signin_as(user) }

    describe 'プロフィール変更' do
      context 'nicknameフォームの入力値が登録可の状態' do
        it 'nicknameの変更に成功できる' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link 'プロフィール'
          expect(page).to have_current_path(profile_path, wait: 1)
          click_link '編集'
          fill_in 'ニックネーム', with: 'てすと'
          click_button '更新'
          expect(page).to have_content '保存されました'
          expect(page).to have_current_path(profile_path, wait: 1)
        end
      end
      context 'nicknameのフォーム入力値が登録不可の状態' do
        it 'nicknameのフォームが未入力で変更を失敗する' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link 'プロフィール'
          expect(page).to have_current_path(profile_path, wait: 1)
          click_link '編集'
          fill_in 'ニックネーム', with: nil
          click_button '更新'
          expect(page).to have_content 'ニックネームを入力してください'
          expect(page).to have_current_path(edit_profile_path, wait: 1)
        end
      end
    end
  end
end
