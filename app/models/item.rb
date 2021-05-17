class Item < ApplicationRecord
  
  has_many :cart_items
  has_many :oreders, through: :order_items
  has_many :order_items
  belongs_to :genre
  
  attachment :image
    
end
