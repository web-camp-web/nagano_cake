class OrderItem < ApplicationRecord
  enum product_status: {着手不可:0, 製作待ち:1, 製作中:2, 製作完了:3}

  belongs_to :order
  belongs_to :item

  validates :item_id, :order_id, :quantity, :market_price, presence: true

  def order_status_auto_update
    if self.product_status == "製作中"
      self.order.update_attributes(status: "製作中")
    end
  end

  def product_complete_auto_update
    order_items = self.order.order_items
    product_status = order_items.pluck(:product_status)
     if product_status.all?{ |product_status| product_status == "製作完了"}
       self.order.update_attributes(status: "発送準備中")
     end
  end

end
