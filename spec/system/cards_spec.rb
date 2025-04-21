require 'rails_helper'

RSpec.describe "Cards", type: :system do
  let(:user) { create(:user, confirmed_at: Time.current) }
  describe 'サインイン前' do
    describe 'ページ遷移確認' do
      context 'カードの一覧ページにアクセスする' do
        it '全てのカードが表示される' do
          visit root_path
          click_link 'タイムラインを覗いてみる'
          expect(page).to have_current_path(cards_path, wait: 1)
        end
      end
      context 'カードの新規作成ページにアクセスする' do
        it 'アクセスが失敗する' do
          visit new_card_path
          expect(page).to have_content 'この操作を続けるには新規登録又はサインインしてください。'
          expect(page).to have_current_path(user_session_path, wait: 1)
        end
      end
    end
  end
  describe 'サインイン後' do
    before { signin_as(user) }
    describe 'カードの新規登録' do
      context 'フォームの入力値が登録可の状態' do
        it 'カードの新規登録が成功する' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link '新規投稿'
          expect(page).to have_content 'New Card'
          expect(page).to have_current_path(new_card_path, wait: 5)
          fill_in 'タイトル', with: 'メンダコ'
          fill_in '本文', with: 'どっこいしょ'
          fill_in 'リンク', with: 'https://youtu.be/Ez0WVxobsRo?si=6p1JaOMylJVRva8t'
          click_button '登録'
          expect(page).to have_content '投稿されました'
          expect(page).to have_current_path(cards_path, wait: 1)
        end
      end
      context 'フォームの入力値が登録不可の状態' do
        it 'タイトルが空でカードの新規登録失敗' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link '新規投稿'
          expect(page).to have_selector('h1', text: 'New Card', wait: 5)
          expect(page).to have_current_path(new_card_path, wait: 5)
          fill_in 'タイトル', with: nil
          fill_in '本文', with: 'どっこいしょ'
          fill_in 'リンク', with: 'https://youtu.be/Ez0WVxobsRo?si=6p1JaOMylJVRva8t'
          click_button '登録'
          expect(page).to have_content '投稿に失敗しました'
          expect(page).to have_content 'タイトルを入力してください'
          expect(page).to have_current_path(new_card_path, wait: 1)
        end
        it 'メッセージが空でカードの新規登録失敗' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link '新規投稿'
          expect(page).to have_selector('h1', text: 'New Card', wait: 3)
          expect(page).to have_current_path(new_card_path, wait: 3)
          fill_in 'タイトル', with: 'メンダコ'
          fill_in '本文', with: nil
          fill_in 'リンク', with: 'https://youtu.be/Ez0WVxobsRo?si=6p1JaOMylJVRva8t'
          click_button '登録'
          expect(page).to have_content '投稿に失敗しました'
          expect(page).to have_content '本文を入力してください'
          expect(page).to have_current_path(new_card_path, wait: 1)
        end
        it 'リンクが空でカードの新規登録失敗' do
          expect(page).to have_current_path(user_root_path, wait: 1)
          find('.hamburger-menu').click
          click_link '新規投稿'
          expect(page).to have_selector('h1', text: 'New Card', wait: 3)
          expect(page).to have_current_path(new_card_path, wait: 3)
          fill_in 'タイトル', with: 'メンダコ'
          fill_in '本文', with: 'どっこいしょ'
          fill_in 'リンク', with: nil
          click_button '登録'
          expect(page).to have_content '投稿に失敗しました'
          expect(page).to have_content 'リンクを入力してください'
          expect(page).to have_content 'リンクはYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)'
          expect(page).to have_current_path(new_card_path, wait: 1)
        end
      end
    end
    describe 'カードの削除' do
      it 'カードが削除できること' do
        card = new_card
        expect(page).to have_current_path(cards_path, wait: 3)
        expect(page).to have_content card.title
        find('.kebab-menu').click
        click_link '削除'
        expect(page.accept_confirm).to eq '本当に削除しますか？'
        expect(page).to have_content '削除されました'
        expect(page).to have_current_path(cards_path, wait: 3)
        expect(page).not_to have_content card.title
      end
    end
  end
end
