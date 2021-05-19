class Item < ApplicationRecord

  has_many :cart_items, dependent: :destroy
  has_many :oreders, through: :order_items
  has_many :order_items
  belongs_to :genre

  attachment :image

  validates :name, :genre_id, :image, :caption, :price, :is_active, presence: true

end
