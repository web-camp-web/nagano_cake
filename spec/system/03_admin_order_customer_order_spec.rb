require 'rails_helper'

describe '1.マスタ登録のテスト' do
  let!(:admin) { create(:admin) }
  let!(:customer) { create(:customer) }
  let!(:genre) { create(:genre) }
  let!(:item) { create(:item) }
  let!(:order) { create(:order) }
  let!(:order_item) { create(:order_item) }
  let!(:item_2) { create(:item) }

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

  context '管理者のトップ画面のテスト' do
    it 'ログイン後、ヘッダーに注文履歴一覧のリンクが存在する' do
      expect(page).to have_link '注文履歴一覧'
    end
  end

    it '注文履歴一覧をクリックすると注文一覧ページが表示される' do
      click_link '注文履歴一覧'
      expect(current_path).to eq admin_orders_path
    end

    context '注文履歴一覧画面のテスト' do
      before do
        visit admin_orders_path
      end

      it "注文一覧画面の中に注文詳細画面へのリンク先が表示される" do
        expect(page).to have_css '.rspecorder'
      end
    end

    context '注文詳細画面のテスト' do
      before do
        visit admin_order_path(order.id)
      end


    it '注文ステータスを入金確認に変更すると制作ステータスが制作待ちに更新される' do
      # expect(page).to have_content '入金待ち'
      select "入金確認", from: 'order[status]'
      find(".order_btn").click
      expect(order_item.reload.product_status).to eq "製作待ち"
    end

    it '製作ステータスを１つ製作中に変更する' do
      select "製作中", from: 'order_item[product_status]'
      find('.order_item_btn').click
      expect(order.reload.status).to eq "製作中"
    end


    before do

    OrderItem.create(item_id: 2, order_id: 1, quantity: 1, market_price: item_2.price, product_status: 3)

    end

    it '全ての商品の製作ステータスを製作完了にしたら注文ステータスが発送待ちに更新されるか' do
        select "製作完了", from: 'order_item[product_status]'
        find('.order_item_btn').click
        expect(order.reload.status).to eq '発送準備中'
    end




    it '注文ステータスを発送済みに変更し更新されるか' do
      select "発送済み", from: 'order[status]'
      find('.order_btn').click
      expect(order.reload.status).to eq '発送済み'
    end

    it 'ヘッダのログアウトリンクを押下したらログアウトされる' do
      click_link 'ログアウト'
      expect(current_path).to eq new_admin_session_path
    end
  end
end

describe 'ECサイト（顧客側のテスト）' do
  let!(:customer) {create(:customer)}
  let!(:genre) { create(:genre) }
  let!(:item) { create(:item) }
  let!(:order) { create(:order) }
  let!(:order_item) { create(:order_item) }

  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  context '顧客のログインテスト' do
    it 'ログイン後、トップ画面になっているか' do
      expect(current_path).to eq root_path
    end

    context 'ログイン後のヘッダの表示が正しいか' do
      it 'ヘッダにマイページのリンクがあるか' do
        expect(page).to have_link 'マイページ', href: customer_path(1)
      end
      it 'ヘッダに商品一覧ページのリンクがあるか' do
        expect(page).to have_link '商品一覧', href: items_path
      end
      it 'ヘッダにカートページのリンクがあるか' do
        expect(page).to have_link 'カート', href: cart_items_path
      end
      it 'ヘッダにログアウトのリンクがあるか' do
        expect(page).to have_link 'ログアウト', href: destroy_customer_session_path
      end
    end
    context 'ヘッダからマイページへ遷移' do
      it 'マイページリンクを押下してマイページが表示されるか' do
        click_on 'マイページ'
        expect(current_path).to eq customer_path(1)
      end
    end
  end


  context '顧客側の注文一覧ページのテスト' do
    before do
      visit customer_path(1)
    end

      it 'マイページに注文履歴一覧のリンクが存在するか' do
        expect(page).to have_link '一覧を見る', href: orders_path
      end

      it '注文履歴一覧を押下したら注文履歴一覧ページが表示されるか' do
        find(".order_btn").click
        expect(current_path).to eq orders_path
      end

      context '注文詳細ページのテスト' do
        before do
          visit orders_path
          OrderItem.find(1).update(product_status: 3)
          Order.find(1).update(status: 4)

        end
        it '注文した注文詳細表示リンクがあるか' do
          expect(page).to have_link '表示する', href: order_path(1)
        end


      it '注文詳細履歴ボタンを押下して遷移するか' do
        click_on '表示する'
        expect(current_path).to eq order_path(1)
      end
      it '注文ステータスが発送済みになっているか' do
        visit order_path(1)
        expect(page).to have_content '発送済み'
      end
    end


  end

end