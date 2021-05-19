require 'rails_helper'

describe '4.登録情報変更〜退会のテスト' do
  let!(:customer) { create(:customer) }

  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  context 'マイページのテスト' do
    it '「編集する」を押すと会員情報編集画面に遷移する' do
      visit customer_path(customer)
      click_link '編集する'
      expect(current_path).to eq edit_customer_path(customer)
    end
  end

  context '会員情報編集画面とマイページのテスト' do
    before do
      visit edit_customer_path(customer)
      fill_in 'customer[last_name]', with: '山田'
      fill_in 'customer[first_name]', with: '太郎'
      fill_in 'customer[last_name_kana]', with: 'ヤマダ'
      fill_in 'customer[first_name_kana]', with: 'タロウ'
      fill_in 'customer[postcode]', with: '1234567'
      fill_in 'customer[address]', with: '京都府京都市金閣寺町1234'
      fill_in 'customer[phone_number]', with: '09012345678'
      fill_in 'customer[email]', with: 'yamada@tarou.com'
      click_button '編集内容を保存'
    end

    it '全項目を編集し「編集内容を保存」を押すとマイページに遷移する' do
      expect(current_path).to eq customer_path(customer)
    end

    it 'マイページに変更した内容が表示されている' do
      expect(page).to have_content '山田' and '太郎' and 'ヤマダ' and 'タロウ' and '1234567' and '京都府京都市金閣寺町1234' and '09012345678' and 'yamada@tarou.com'
    end

    it 'マイページで配送先の「一覧を表示する」ボタンを押すと配送先一覧画面に遷移する' do
      find('a[href="/deliveries"]').click
      expect(current_path).to eq deliveries_path
    end
  end

  context '配送先一覧画面のテスト' do
    before do
      visit deliveries_path
      fill_in 'delivery[postcode]', with: '7654321'
      fill_in 'delivery[address]', with: '大阪府大阪市北区9876'
      fill_in 'delivery[name]', with: '山田花子'
      click_button '新規登録'
    end

    it '各項目を入力し、新規登録ボタンを押すと自画面が再描画される' do
      expect(current_path).to eq deliveries_path
    end

    it '登録した内容が配送先一覧画面に反映されている' do
      expect(page).to have_content '7654321' and '大阪府大阪市北区9876' and '山田花子'
    end

    it 'ヘッダーのロゴを押すとトップ画面に遷移する' do
      find('a[href="/"]').click
      expect(current_path).to eq root_path
    end
  end
end