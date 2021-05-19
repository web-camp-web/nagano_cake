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
      fill_in 'item[name]', with: 'いちごのケーキ(ホール)'
      fill_in 'item[caption]', with: '高級いちごを贅沢に使用しています'
      select genre.name, from: 'item[genre_id]'
      fill_in 'item[price]', with: 3000
      click_button '送信'
      expect(page).to have_content '商品詳細'
      expect(page).to have_content 'いちごのケーキ(ホール)'
    end
  end

  context '商品詳細画面のテスト' do
    let!(:genre) { create(:genre) }
    let!(:item) { create(:item) }

    before do
      visit admin_item_path(item)
    end

    it 'ヘッダーに「商品一覧」というリンクがある' do
      expect(page).to have_link '商品一覧'
    end

    it '「商品一覧」のリンクを押すと商品一覧画面が表示される' do
      click_link '商品一覧'
      expect(current_path).to eq admin_items_path
    end
  end

  context '商品一覧画面(1商品登録後)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:item) { create(:item) }

    before do
      visit admin_items_path
    end

    it '登録した商品が表示されている' do
      expect(page).to have_content item.name and item.price and item.genre and item.is_active
    end

    it '「商品作成はこちら」というリンクを押すと商品新規登録画面が表示される' do
      click_link '商品作成はこちら'
      expect(current_path).to eq new_admin_item_path
    end
  end

  context '商品新規登録(2商品目)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:item) { create(:item) }

    before do
      visit new_admin_item_path
    end

    it '必要事項を入力して登録ボタンを押すと登録した商品の詳細画面が表示される' do
      attach_file 'item[image]', "#{Rails.root}/app/assets/images/strawberry-cake.jpg"
      fill_in 'item[name]', with: 'りんごのケーキ(ホール)'
      fill_in 'item[caption]', with: '高級りんごを贅沢に使用しています'
      select genre.name, from: 'item[genre_id]'
      fill_in 'item[price]', with: 2500
      click_button '送信'
      expect(page).to have_content '商品詳細'
      expect(page).to have_content 'りんごのケーキ(ホール)'
    end
  end

  context '商品詳細画面(2商品登録後)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:item_1) { create(:item) }
    let!(:item_2) { create(:item) }

    before do
      visit admin_item_path(item_2)
    end

    it 'ヘッダーに「商品一覧」というリンクがある' do
      expect(page).to have_link '商品一覧'
    end

    it '「商品一覧」のリンクを押すと商品一覧画面が表示される' do
      click_link '商品一覧'
      expect(current_path).to eq admin_items_path
    end
  end

  context '商品一覧画面(2商品登録後)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:item_1) { create(:item) }
    let!(:item_2) { create(:item) }

    before do
      visit admin_items_path
    end

    it '登録した商品が2つとも表示されている' do
      expect(page).to have_content item_1.name and item_1.price and item_1.genre and item_1.is_active
      expect(page).to have_content item_2.name and item_2.price and item_2.genre and item_2.is_active
    end

    it '「ログアウト」リンクを押すと管理者ログイン画面に遷移する' do
      click_link 'ログアウト'
      expect(current_path).to eq new_admin_session_path
    end
  end
end