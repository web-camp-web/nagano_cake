class Delivery < ApplicationRecord
  
  belongs_to :customer
  
  validates :customer_id, :name, :address, , presence: true

end
