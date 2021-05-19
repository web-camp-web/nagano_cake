require 'rails_helper'

describe '管理者ログイン~ジャンル登録~商品登録~ログアウトのテスト' do
  let!(:admin) { create(:admin) }

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

  context '管理者ログインのテスト' do
    it 'ログイン後、管理者の注文履歴一覧が表示される' do
      expect(current_path).to eq admin_orders_path
    end
  end

  context 'ヘッダーのジャンル一覧を押すと、ジャンル一覧画面が表示される' do
    it 'ログイン後、ヘッダーにジャンル一覧のリンクが表示されている' do
      expect(page).to have_link 'ジャンル一覧'
    end

    it 'ジャンル一覧のリンクを押すとジャンル一覧画面が表示される' do
      click_link 'ジャンル一覧'
      expect(current_path).to eq admin_genres_path
    end
  end
end