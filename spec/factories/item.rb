FactoryBot.define do
  factory :item do
    genre_id { 1 }
    name { Faker::Food.fruits }
    image_id { Faker::Lorem.characters(number:10) }
    caption { Faker::Lorem.characters(number:10) }
    price { Faker::Number.number(digits: 4) }
  end
end