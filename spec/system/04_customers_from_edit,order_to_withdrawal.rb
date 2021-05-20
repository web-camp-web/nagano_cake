require 'rails_helper'

describe '4.登録情報変更〜退会のテスト' do
  let!(:customer) { create(:customer) }

  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  describe '登録情報変更〜配送先一覧画面のテスト' do
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
        expect(page).to have_content '山田'
        expect(page).to have_content '太郎'
        expect(page).to have_content 'ヤマダ'
        expect(page).to have_content 'タロウ'
        expect(page).to have_content '1234567'
        expect(page).to have_content '京都府京都市金閣寺町1234'
        expect(page).to have_content '09012345678'
        expect(page).to have_content 'yamada@tarou.com'
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
        expect(page).to have_content '7654321'
        expect(page).to have_content '大阪府大阪市北区9876'
        expect(page).to have_content '山田花子'
      end

      it 'ヘッダーのロゴを押すとトップ画面に遷移する' do
        find('a[href="/"]').click
        expect(current_path).to eq root_path
      end
    end
  end

  describe 'トップ画面〜退会のテスト' do
    let!(:genre) { create(:genre) }
    let!(:item) { create(:item) }
    let!(:cart_item) { create(:cart_item) }

    context 'トップ画面〜商品詳細画面のテスト' do
      before do
        visit root_path
        click_on 'item-image'
      end

      it '任意の商品画像を押すと、該当の商品詳細画面に遷移する' do
        expect(current_path).to eq item_path(item)
      end

      it '商品詳細画面で、該当の商品詳細が表示されている' do
        tax_price = (item.price * 1.1).floor
        expect(page).to have_content item.name
        expect(page).to have_content tax_price
      end
    end

    context '商品詳細画面〜カート画面のテスト' do
      before do
        visit item_path(item)
        select 3, from: 'cart_item[quantity]'
        click_button 'カートに入れる'
      end

      it '商品詳細画面で個数を選択し、「カートに入れる」ボタンを押すとカート画面に遷移する' do
        expect(current_path).to eq cart_items_path
      end

      it 'カート画面で、カートの中身が正しく表示されている' do
        tax_price = (item.price * 1.1).floor
        sub_price = tax_price * cart_item.quantity
        visit cart_items_path
        expect(page).to have_content item.name
        expect(page).to have_content tax_price
        expect(page).to have_content sub_price
      end
    end
  end
end