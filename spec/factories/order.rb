FactoryBot.define do
  factory :order do
    customer_id { 1 }
    postage { 800 }
    total_price { ((Item.find(1).price * 1.1).floor * CartItem.find(1).quantity) + 800 }
    delivery_name { Gimei.kanji }
    delivery_address { Gimei.address.kanji }
    delivery_postcode { Faker::Address.postcode }
  end
end
