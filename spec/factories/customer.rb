FactoryBot.define do
  factory :customer do
    email { Faker::Internet.free_email }
    password { Faker::Internet.password }
    last_name { Gimei.last.kanji }
    first_name { Gimei.first.kanji }
    last_name_kana { Gimei.last.katakana }
    first_name_kana { Gimei.first.katakana }
    postcode { Faker::Address.postcode }
    address { Faker::Address.full_address }
    phone_number { Faker::Number.number(digits: 11) }
  end
end