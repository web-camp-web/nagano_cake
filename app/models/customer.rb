class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :orders ,dependent: :destroy
  has_many :deliveries, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :address, :phone_number, :postcode, presence: true
  

  def active_for_authentication?
    super && (self.is_valid == true)
  end
  
  
end
