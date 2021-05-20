require 'rails_helper'

describe '4.顧客登録情報変更〜退会のテスト' do
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
    let!(:delivery) { create(:delivery) }

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
        expect(page).to have_selector 'input[value=4]'
      end
    end

    describe 'カート画面〜注文情報入力画面〜マイページのテスト' do
      before do
        visit item_path(item)
        select 3, from: 'cart_item[quantity]'
        click_button 'カートに入れる'
        click_link '情報入力に進む'

        def check_payment_and_fill_in_new_address_and_click_button
          choose "order_payment_method_銀行振込"
          choose 'order_delivery_address_新しい届け先'
          fill_in 'order[new_postcode]', with: '0000000'
          fill_in 'order[new_address]', with: '東京都渋谷区代々木神園町0-0'
          fill_in 'order[new_name]', with: '令和道子'
          click_button '確認画面へ進む'
        end

      end

      context 'カート画面〜注文情報入力画面のテスト' do
        it 'カート画面で「情報入力に進む」ボタンを押すと注文情報入力画面に遷移する' do
          expect(current_path).to eq new_order_path
        end

        it '注文情報入力画面で、登録した住所が選択できるようになっている' do

          def delivery_full_address
            '〒' + delivery.postcode + ' ' + delivery.address + ' ' + delivery.name
          end

          expect(page).to have_select 'order[delivery_address_id]', options: [delivery_full_address]
        end
      end

      context '注文情報入力〜確定画面のテスト' do
        before do
          check_payment_and_fill_in_new_address_and_click_button
        end

        it '任意の支払い方法、新しい住所を入力し、購入ボタンを押すと確認画面に遷移する' do
          expect(current_path).to eq orders_confirm_path
        end

        it '注文情報確認画面に選択した商品名と個数が表示されている' do
          tax_price = (item.price * 1.1).floor
          sub_price =  tax_price * 4
          expect(page).to have_content item.name
          expect(page).to have_content 4
          expect(page).to have_content sub_price.to_s(:delimited)
        end

        it '注文情報確認画面に選択した支払い方法が表示されている' do
          expect(page).to have_content '銀行振込'
        end

        it '注文情報確認画面に、新しく入力した住所が表示されている' do
          expect(page).to have_content '〒0000000 東京都渋谷区代々木神園町0-0 令和道子'
        end

        it '注文情報確認画面で、「注文を確定する」を押すとサンクスページに遷移する' do
          click_button '注文を確定する'
          expect(current_path).to eq orders_complete_path
        end
      end

      context 'サンクスページ〜マイページのテスト' do
        it 'サンクスページのヘッダーからトップ画面へのリンクを押すとトップ画面に遷移する' do
          visit orders_complete_path
          find('a[href="/"]').click
          expect(current_path).to eq root_path
        end

        it 'トップ画面のヘッダーからマイページへのリンクを押すとマイページへ遷移する' do
          visit root_path
          click_link 'マイページ'
          expect(current_path).to eq customer_path(customer)
        end
      end

      context 'マイページ〜配送先一覧画面のテスト' do
        before do
          check_payment_and_fill_in_new_address_and_click_button
        end

        it 'マイページで配送先一覧へのリンクを押すと配送先一覧画面へ遷移する' do
          visit customer_path(customer)
          find('a[href="/deliveries"]').click
          expect(current_path).to eq deliveries_path
        end

        it '配送先一覧画面に、注文時に新しく入力した住所が表示されている' do
          visit deliveries_path
          expect(page).to have_content '0000000'
          expect(page).to have_content '東京都渋谷区代々木神園町0-0'
          expect(page).to have_content '令和道子'
        end
      end

      context 'マイページ〜退会のテスト' do
        it 'マイページで顧客情報編集画面へのリンクを押すと、顧客情報編集画面へ遷移する' do
          visit customer_path(customer)
          click_link '編集する'
          expect(current_path).to eq edit_customer_path(customer)
        end

        it '顧客情報編集画面で退会ボタンを押すと、アラートが表示される' do
          visit edit_customer_path(customer)
          click_link '退会する'
          expect(current_path).to eq destroy_confirm_path(customer)
        end

        it '退会確認画面で「退会する」ボタンを押すと、トップ画面に遷移する' do
          visit destroy_confirm_path(customer)
          click_link '退会する'
          expect(current_path).to eq root_path
        end
      end

      context '退会後の確認テスト' do
        before do
          visit destroy_confirm_path(customer)
          click_link '退会する'
        end

        it '退会後のトップ画面で、ヘッダーが未ログイン状態になっている' do
          expect(page).to have_link 'ログイン'
          expect(page).to have_link 'About'
          expect(page).to have_link '新規登録'
        end

        it '退会後のトップ画面で、ヘッダーの「ログイン」リンクを押すとログイン画面に遷移する' do
          click_link 'ログイン'
          expect(current_path).to eq new_customer_session_path
        end

        it '退会したアカウントでログインができなくなっている' do
          visit new_customer_session_path
          fill_in 'customer[email]', with: customer.email
          fill_in 'customer[password]', with: customer.password
          click_button 'ログイン'
          expect(current_path).to eq new_customer_session_path
        end
      end
    end
  end
end

describe '4.管理者ログイン〜ログアウトのテスト' do
  let!(:customer) { create(:customer) }
  let!(:admin) { create(:admin) }

  def admin_log_in
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

  def customer_log_in
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  context 'ログイン画面〜顧客詳細画面のテスト' do
    before do
      customer_log_in
      visit destroy_confirm_path(customer)
      click_link '退会する'
      admin_log_in
    end

    it '管理者ログイン画面で、メールアドレスとパスワードでログインすると管理者トップ画面(顧客注文履歴一覧画面)に遷移する' do
      expect(current_path).to eq admin_orders_path
    end

    it '管理者トップ画面(顧客注文履歴一覧画面)で、顧客一覧へのリンクを押すと顧客一覧画面に遷移する' do
      click_link '顧客一覧'
      expect(current_path).to eq admin_customers_path
    end

    it '顧客一覧画面で退会ユーザが「退会」表示になっている' do
      visit admin_customers_path
      expect(page).to have_content customer.id
      expect(page).to have_content (customer.last_name + customer.first_name)
      expect(page).to have_content customer.email
      expect(page).to have_content '退会'
      expect(customer.reload.is_valid).to be false
    end

    it '顧客一覧画面で顧客の名前を押すと、該当の顧客詳細画面に遷移する' do
      visit admin_customers_path
      click_link (customer.last_name + customer.first_name)
      expect(current_path).to eq admin_customer_path(customer)
    end
  end

  context '顧客詳細画面〜ログアウトのテスト' do
    before do
      customer_log_in
      visit customer_path(customer)
      click_link '編集する'
      fill_in 'customer[address]', with: '大阪府大阪市北区0000'
      click_button '編集内容を保存'

      admin_log_in
      visit admin_customer_path(customer)
    end

    it '顧客詳細画面で、顧客が変更した住所が表示されている' do
      expect(page).to have_content '大阪府大阪市北区0000'
    end

    it 'ヘッダーのログアウトリンクを押すと、管理者ログイン画面に遷移する' do
      #顧客ログアウト
      click_link 'ログアウト'
      #管理者ログアウト
      click_link 'ログアウト'
      expect(current_path).to eq new_admin_session_path
    end
  end
end