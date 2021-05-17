class Delivery < ApplicationRecord

  belongs_to :customer

  validates :customer_id, :name, :address, presence: true

  def delivery_full_address
    '〒' + self.postcode + ' ' + self.address + ' ' + self.name
  end

end
