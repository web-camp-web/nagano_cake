FactoryBot.define do
  factory :admin do
    email { Faker::Internet.free_email }
    password { Faker::Internet.password }
  end
end