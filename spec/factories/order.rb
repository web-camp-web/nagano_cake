FactoryBot.define do
  factory :order do
    customer_id { 1 }
    postage { 800 }
    total_price { (Item.price * 1.1).floor * CartItem.quantity + postage }
    delivery_name { Gimei.kanji }
    delivery_address { Gimei.address.kanji }
    delivery_postcode { Faker::Address.postcode }
  end
end
