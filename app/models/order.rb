class Order < ApplicationRecord
  
  belongs_to :customer
  has_many :items, thorough: :order_items
  has_many :order_items
end
