FactoryBot.define do
  factory :genre do
    name { Faker::Food.fruits }
  end
end