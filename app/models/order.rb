class Order < ApplicationRecord
  enum payment_method: {クレジットカード:0, 銀行振込:1}
  enum status: {入金待ち:0, 入金確認:1, 製作中:2, 発送準備中:3, 発送済み:4}

  belongs_to :customer
  has_many :items

  has_many :order_items

  def order_item_status_auto_update
    if self.status == "入金確認"
      self.order_items.each do |order_item|
        order_item.update_attributes(product_status: "製作待ち")
      end
    #デフォルトで「着手不可」にはなるが、誤って「入金確認」を押した際に製作ステータスを再度「着手不可」へ戻すために以下が必要
    elsif self.status == "入金待ち"
      self.order_items.each do |order_item|
        order_item.update_attributes(product_status: "着手不可")
      end
    end
  end

end
