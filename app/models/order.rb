class Order < ApplicationRecord
  enum payment_method: {クレジットカード:0, 銀行振込:1}

  belongs_to :customer
  has_many :items
  has_many :order_items
end
