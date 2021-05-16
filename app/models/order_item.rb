class OrderItem < ApplicationRecord
  
  belongs_to :order
  belongs_to :item

  validates :item_id, :order_id, :quantity, :market_price, presence: true
end
