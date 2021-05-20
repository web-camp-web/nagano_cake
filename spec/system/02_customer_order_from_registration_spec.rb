require 'rails_helper'

describe '登録〜注文のテスト' do

  context 'トップページのテスト' do
    let!(:customer) { create(:customer) }

    it '新規登録画面へのリンクを押下すると新規登録画面が表示される' do
      visit root_path
      click_on '新規登録'
      expect(current_path).to eq new_customer_registration_path
    end
  end

  describe 'トップページ以降のテスト' do
    before do
      visit new_customer_registration_path
      fill_in 'customer[last_name]', with: "流美衣"
      fill_in 'customer[first_name]', with: "恩零留頭"
      fill_in 'customer[last_name_kana]', with: "ルビー"
      fill_in 'customer[first_name_kana]', with: "オンレイルズ"
      fill_in 'customer[email]', with: "ruby@onrail.com"
      fill_in 'customer[postcode]', with: "ruby_on_rails"
      fill_in 'customer[address]', with: "123456789"
      fill_in 'customer[phone_number]', with: "2222222222"
      fill_in 'customer[password]', with: "testtest"
      fill_in 'customer[password_confirmation]', with: "testtest"
      find(".sign-up-btn").click
    end

    context '新規登録画面のテスト' do
      it '必要事項を入力して登録ボタンを押下するとマイページに遷移する' do
        expect(current_path).to eq customer_path(1)
      end

      it '新規登録画面で入力した情報が表示されている' do
        expect(page).to have_content '流美衣'
        expect(page).to have_content '恩零留頭'
        expect(page).to have_content 'ルビー'
        expect(page).to have_content 'オンレイルズ'
        expect(page).to have_content 'ruby@onrail.com'
        expect(page).to have_content 'ruby_on_rails'
        expect(page).to have_content '123456789'
        expect(page).to have_content '2222222222'
      end

      it 'ヘッダーがログイン後の表示に変わっている' do
        expect(page).to have_link 'マイページ'
        expect(page).to have_link '商品一覧'
        expect(page).to have_link 'カート'
        expect(page).to have_link 'ログアウト'
      end
    end

    context 'ヘッダーロゴのテスト' do
     it 'ヘッダーロゴを押下してトップ画面に遷移することができる' do
        click_on 'NaganoCAKE'
        expect(current_path).to eq root_path
      end
    end

    context 'トップ画面のテスト' do
      let!(:genre) { create(:genre) }
      let!(:item_1) { create(:item) }
      let!(:item_2) { create(:item) }

      it '商品画像を押下して該当商品の詳細画面に遷移する' do
        visit root_path
        find('a[href="/items/1"]').click
        expect(current_path).to eq item_path(1)
      end

      it '押下した商品の商品情報が正しく表示されているか' do
        visit item_path(1)
        expect(page).to have_content item_1.name
        expect(page).to have_content item_1.caption
        expect(page).to have_content (item_1.price * 1.1).floor
        expect(page).to have_content item_1.genre_id
        expect(item_1.is_active).to be true
        #expect(page).to have_selector("img[src$='item_1.jpg']")
      end
    end

    context '商品詳細画面のテスト' do
      let!(:genre) { create(:genre) }
      let!(:item) { create(:item) }

      before do
        visit item_path(1)
        find("option[value='2']").select_option
        click_on 'カートに入れる'
      end

      it '個数を選択し、カートに入れるボタンを押下すると、カート画面に遷移する' do
        expect(current_path).to eq cart_items_path
      end

      it 'カートの中身が正しく表示されているか' do
        visit cart_items_path
        expect(page).to have_content item.name
        expect(page).to have_content (item.price * 1.1).floor
        expect(page).to have_selector ("input[value='2']")
        expect(page).to have_content (item.price * 1.1).floor * 2

      end
    end

    context '商品詳細画面のテスト（２回目）' do
      let!(:genre) { create(:genre) }
      let!(:item_1) { create(:item) }
      let!(:item_2) { create(:item) }
      let!(:cart_item) { create(:cart_item) }

      def tax_price_1
        (item_1.price * 1.1).floor
      end

      def tax_price_2
        (item_2.price * 1.1).floor
      end

      it '既にカートの中身が入っている状況で商品を追加して正しく中身が表示されるか' do
        visit item_path(2)
        find("option[value='3']").select_option
        click_on 'カートに入れる'
        visit cart_items_path
        expect(page).to have_content item_2.name
        expect(page).to have_content tax_price_2 * 3
        expect(page).to have_content tax_price_1 + tax_price_2 * 3
      end
    end

    context 'カート画面のテスト' do
       let!(:genre) { create(:genre) }
       let!(:item) { create(:item) }
       let!(:cart_item) { create(:cart_item) }

       before do
         visit cart_items_path
       end

      it '買い物を続けるボタンを押下するとトップ画面に遷移する' do
        click_on '買い物を続ける'
        expect(current_path).to eq root_path
      end

      it '商品の個数を変更し、更新ボタンを押下すると合計表示が正しく表示される' do
        fill_in 'cart_item[quantity]', with: '3'
        click_on '数量変更'
        expect(page).to have_content (item.price * 1.1).floor * 3
      end

      it '情報入力に進むボタンを押下すると情報入力画面に遷移する' do
        click_on '情報入力に進む'
        expect(current_path).to eq  new_order_path
      end
    end

  end
end