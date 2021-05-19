require 'rails_helper'

describe '1.マスタ登録のテスト' do
  let!(:admin) { create(:admin) }

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

  context '管理者ログインのテスト' do
    it 'ログイン後、管理者トップ（注文履歴一覧）が表示される' do
      expect(current_path).to eq admin_orders_path
    end
  end

  context '管理者トップ画面のテスト' do
    it 'ログイン後、ヘッダーにジャンル一覧のリンクが表示されている' do
      expect(page).to have_link 'ジャンル一覧'
    end

    it 'ジャンル一覧のリンクを押すとジャンル一覧画面が表示される' do
      click_link 'ジャンル一覧'
      expect(current_path).to eq admin_genres_path
    end
  end

  context 'ジャンル一覧画面のテスト' do
    before do
      visit admin_genres_path
    end

    it '必要事項を入力し、登録ボタンを押すと追加したジャンルが表示される' do
      fill_in 'genre[name]', with: 'ケーキ'
      click_button '新規登録'
      expect(page).to have_content 'ケーキ'
    end

    it '商品一覧のリンクを押すと商品一覧画面が表示される' do
      click_link '商品一覧'
      expect(current_path).to eq admin_items_path
    end
  end

  context '商品一覧画面のテスト' do
    before do
      visit admin_items_path
    end

    it '「商品作成はこちら」というリンクを押すと商品新規登録画面が表示される' do
      click_link '商品作成はこちら'
      expect(current_path).to eq new_admin_item_path
    end
  end

  context '商品新規登録画面のテスト' do
    let!(:genre) { create(:genre) }
    before do
      visit new_admin_item_path
    end

    it '必要事項を入力して登録ボタンを押すと登録した商品の詳細画面が表示される' do
      attach_file 'item[image]', "#{Rails.root}/app/assets/images/strawberry-cake.jpg"
      fill_in 'item[name]', with: 'いちごのショートケーキ(ホール)'
      fill_in 'item[caption]', with: '高級いちごを贅沢に使用しています'
      select genre.name, from: 'item[genre_id]'
      fill_in 'item[price]', with: 3000
      #check 'item[is_active]'
      click_button '送信'
      expect(page).to have_content '商品詳細'
      expect(page).to have_content 'いちごのショートケーキ(ホール)'
    end
  end
end