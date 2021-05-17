class Order < ApplicationRecord

  belongs_to :customer
  has_many :order_items

  # has_many :items, thorough: :order_items
end
