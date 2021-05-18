class Delivery < ApplicationRecord

  belongs_to :customer

  validates :postcode, :name, :address, presence: true

end
