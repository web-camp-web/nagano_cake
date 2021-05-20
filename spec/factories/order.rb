FactoryBot.define do
  factory :order do

    customer_id {1}
    postage { 800 }
    total_price { Faker::Alphanumeric.alpha(number: 5) }
    # payment_method { 1 }
    status {0}
    delivery_name { Gimei.first.kanji }
    delivery_postcode { Faker::Number.number(digits: 7) }
    delivery_address { Faker::Address.full_address }

  end
end