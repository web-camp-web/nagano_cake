class CartItem < ApplicationRecord
  belongs_to :item, dependent: :destroy
  belongs_to :customer, dependent: :destroy
  validates :item_id, :customer_id, :quantity, presence: true
end
