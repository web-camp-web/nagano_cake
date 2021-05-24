class CartItem < ApplicationRecord
  belongs_to :item
  belongs_to :customer
  validates :item_id, :customer_id, :quantity, presence: true
end
