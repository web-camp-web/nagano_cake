FactoryBot.define do
  factory :delivery do
    customer_id { 1 }
    name { Gimei.kanji }
    address { Gimei.address.kanji }
    postcode { Faker::Address.postcode }
  end
end