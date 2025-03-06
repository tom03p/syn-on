module NewCardMacros
  def new_card
    expect(page).to have_current_path(user_root_path, wait: 1)
    find('.hamburger-menu').click
    click_link '新規投稿'
    expect(page).to have_current_path(new_card_path, wait: 1)
    fill_in 'タイトル', with: 'てすと'
    fill_in '本文', with: '確認中'
    fill_in 'リンク', with: 'https://youtu.be/Ez0WVxobsRo?si=6p1JaOMylJVRva8t'
    click_button '登録'
    expect(page).to have_content '投稿されました'
    expect(page).to have_current_path(cards_path, wait: 5)

    Card.last
  end
end
