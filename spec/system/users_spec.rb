require 'rails_helper'

RSpec.describe "Users", type: :system do
  include ActiveJob::TestHelper
  let(:user) { create(:user, confirmed_at: Time.current) }

  describe 'サインイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が登録可の状態' do
        it 'ユーザーの新規登録が成功する' do
          ActionMailer::Base.deliveries.clear
          visit new_user_registration_path
          fill_in 'メールアドレス', with: 'tester@mail.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content '確認リンクを含むメッセージをあなたのメールアドレスに送信しました。リンクをクリックしてアカウントを有効にしてください。'
          expect(page).to have_current_path(root_path, wait: 1)
          expect(ActionMailer::Base.deliveries.size).to eq 1
          mail = ActionMailer::Base.deliveries.last
          confirmation_url = extract_confirmation_url(mail)
          visit confirmation_url
          expect(page).to have_content 'Sign in'
          fill_in 'メールアドレス', with: 'tester@mail.com'
          fill_in 'パスワード', with: 'password'
          click_button 'サインイン'
          expect(page).to have_content 'サインインしました。'
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
      context 'メールのでのユーザー確認' do
        it '確認メールからユーザー確認できていない場合ログインに失敗する' do
          user1 = create(:user)
          visit user_session_path
          expect(page).to have_content 'Sign in'
          fill_in 'メールアドレス', with: user1.email
          fill_in 'パスワード', with: user1.password
          click_button 'サインイン'
          expect(page).to have_content 'この操作を続ける前にメールアドレスを確認してください。'
          expect(page).to have_current_path(user_session_path, wait: 1)
        end
        it '確認メールを再送信してユーザー確認した場合ログインに成功する' do
          user1 = create(:user)
          visit user_session_path
          ActionMailer::Base.deliveries.clear
          expect(page).to have_content 'Sign in'
          click_link '確認メールが来ない場合はこちら'
          expect(page).to have_content 'Resend email'
          fill_in 'メールアドレス', with: user1.email
          click_button '送信'
          expect(page).to have_content '数分以内にメールアドレス確認用のメールが届きます。'
          expect(page).to have_current_path(user_session_path, wait: 1)
          expect(ActionMailer::Base.deliveries.size).to eq 1
          mail = ActionMailer::Base.deliveries.last
          confirmation_url = extract_confirmation_url(mail)
          visit confirmation_url
          expect(page).to have_content 'Sign in'
          fill_in 'メールアドレス', with: user1.email
          fill_in 'パスワード', with: user1.password
          click_button 'サインイン'
          expect(page).to have_content 'サインインしました。'
          expect(page).to have_current_path(user_root_path, wait: 1)
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
      it '設定ページへのアクセスが失敗する' do
        visit static_pages_setting_path
        expect(page).to have_content 'この操作を続けるには新規登録又はサインインしてください。'
        expect(page).to have_current_path(user_session_path, wait: 1)
      end
      it 'メールアドレス変更ページへのアクセスが失敗する' do
        visit edit_user_registration_path
        expect(page).to have_content 'この操作を続けるには新規登録又はサインインしてください。'
        expect(page).to have_current_path(user_session_path, wait: 1)
      end
      it 'パスワードリセットページへのアクセスが失敗する' do
        visit edit_account_password_path
        expect(page).to have_content 'この操作を続けるには新規登録又はサインインしてください。'
        expect(page).to have_current_path(user_session_path, wait: 1)
      end
      it 'アカウント削除ページへのアクセスが失敗する' do
        visit account_exit_path
        expect(page).to have_content 'この操作を続けるには新規登録又はサインインしてください。'
        expect(page).to have_current_path(user_session_path, wait: 1)
      end
    end
  end

  describe 'サインイン後' do
    before { signin_as(user) }
    describe 'アカウント情報変更' do
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
      describe 'メールアドレス変更' do
        context 'フォームの入力値が登録可の状態' do
          it 'メールアドレスの変更に成功できる' do
            ActionMailer::Base.deliveries.clear
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'メールアドレスの変更 →'
            expect(page).to have_content 'Edit Email'
            fill_in 'メールアドレス', with: 'tester2@mail.com'
            click_button '更新'
            expect(page).to have_content 'カウントは正常に更新されましたが、新しいメールアドレスを確認する必要があります。メールを確認し、確認リンクをクリックしてください。'
            expect(page).to have_current_path(user_root_path, wait: 1)
            expect(ActionMailer::Base.deliveries.size).to eq 1
            mail = ActionMailer::Base.deliveries.last
            confirmation_url = extract_confirmation_url(mail)
            visit confirmation_url
            expect(page).to have_content 'メールアドレスを確認しました。'
            expect(page).to have_current_path(user_root_path, wait: 1)
          end
          it 'メールアドレスを変更しなくても問題なく維持される' do
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'メールアドレスの変更 →'
            expect(page).to have_content 'Edit Email'
            click_button '更新'
            expect(page).to have_content 'あなたのアカウントは正常に更新されました。'
            expect(page).to have_current_path(user_root_path, wait: 1)
          end
        end
        context 'フォーム入力値が登録不可の状態' do
          it 'メールアドレスの変更フォームが未入力で変更が失敗する' do
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'メールアドレスの変更 →'
            expect(page).to have_content 'Edit Email'
            fill_in 'メールアドレス', with: nil
            click_button '更新'
            expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
            expect(page).to have_content 'メールアドレスを入力してください'
            expect(page).to have_current_path(edit_user_registration_path, wait: 1)
          end
          it '登録済のメールアドレスを入力して変更が失敗する' do
            user1 = create(:user)
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'メールアドレスの変更 →'
            expect(page).to have_content 'Edit Email'
            fill_in 'メールアドレス', with: user1.email
            click_button '更新'
            expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
            expect(page).to have_content 'メールアドレスはすでに存在します'
            expect(page).to have_current_path(edit_user_registration_path, wait: 1)
          end
        end
      end
      describe 'パスワード変更' do
        context 'フォームの入力値が登録可の状態' do
          it 'パスワードの変更に成功できる' do
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'パスワードリセット →'
            expect(page).to have_content 'Edit Password'
            fill_in '現在のパスワード', with: user.password
            fill_in 'パスワード', with: 'edit_passsword'
            fill_in 'パスワード確認', with: 'edit_passsword'
            click_button '更新'
            expect(page).to have_content 'パスワードが変更されました。'
            expect(page).to have_current_path(user_root_path, wait: 1)
          end
        end
        context 'フォーム入力値が登録不可の状態' do
          it '現在のパスワードが間違っていたらパスワードの変更に失敗する' do
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'パスワードリセット →'
            expect(page).to have_content 'Edit Password'
            fill_in '現在のパスワード', with: 'edit_passsword'
            fill_in 'パスワード', with: 'edit_passsword'
            fill_in 'パスワード確認', with: 'edit_passsword'
            click_button '更新'
            expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
            expect(page).to have_content '現在のパスワードは不正な値です'
            expect(page).to have_current_path(edit_account_password_path, wait: 1)
          end
          it '新しいパスワードが未記入だったならパスワードの変更に失敗する' do
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'パスワードリセット →'
            expect(page).to have_content 'Edit Password'
            fill_in '現在のパスワード', with: user.password
            fill_in 'パスワード', with: nil
            fill_in 'パスワード確認', with: nil
            click_button '更新'
            expect(page).to have_content 'パスワードが入力されていません。有効なパスワードを記入してください。'
            expect(page).to have_current_path(edit_account_password_path, wait: 1)
          end
          it 'パスワード確認が新しいパスワードと違っていたらパスワードの変更に失敗する' do
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'パスワードリセット →'
            expect(page).to have_content 'Edit Password'
            fill_in '現在のパスワード', with: user.password
            fill_in 'パスワード', with: 'edit_passsword'
            fill_in 'パスワード確認', with: 'edit2_passsword'
            click_button '更新'
            expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
            expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
            expect(page).to have_current_path(edit_account_password_path, wait: 1)
          end
          it '新しいパスワードの文字数が足りていなかったらパスワードの変更に失敗する' do
            expect(page).to have_current_path(user_root_path, wait: 1)
            find('.hamburger-menu').click
            click_link '設定'
            expect(page).to have_content 'Setting'
            click_link 'パスワードリセット →'
            expect(page).to have_content 'Edit Password'
            fill_in '現在のパスワード', with: user.password
            fill_in 'パスワード', with: 'ep'
            fill_in 'パスワード確認', with: 'ep'
            click_button '更新'
            expect(page).to have_content 'エラーによってこのユーザーは保存出来ませんでした。'
            expect(page).to have_content 'パスワードは6文字以上で入力してください'
            expect(page).to have_current_path(edit_account_password_path, wait: 1)
          end
        end
      end
      describe 'アカウント削除' do
        it 'アカウント削除に成功すること' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link '設定'
          expect(page).to have_content 'Setting'
          click_link 'アカウントの削除 →'
          expect(page).to have_content 'Cancel my account'
          click_link 'アカウント削除'
          expect(page.accept_confirm).to eq '本当に削除しますか？ この操作は取り消せません。'
          expect(page).to have_content 'アカウントが削除されました。また会えるのを楽しみにしています。'
          expect(page).to have_current_path(root_path, wait: 1)
          visit user_session_path
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: user.password
          click_button 'サインイン'
          expect(page).to have_content 'メールアドレス 又はパスワードが無効です。'
          expect(page).to have_current_path(user_session_path, wait: 1)
        end
        it 'アカウントの削除ページから引き返せること' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link '設定'
          expect(page).to have_content 'Setting'
          click_link 'アカウントの削除 →'
          expect(page).to have_content 'Cancel my account'
          click_link 'Back'
          expect(page).to have_current_path(static_pages_setting_path, wait: 1)
        end
      end
    end
  end
end
