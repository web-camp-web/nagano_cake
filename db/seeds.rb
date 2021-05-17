# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Customer.create!(
    email: "customer@test.com",
    first_name: "一郎",
    last_name: "山田",
    first_name_kana: "イチロウ",
    last_name_kana: "ヤマダ",
    password: "testtest",
    postcode: "1310045",
    address: "東京都墨田区押上1丁目1−12",
    phone_number: "09012345678"
  )

Delivery.create!(
    customer_id: 1,
    name: "鈴木花子",
    address: "京都府京都市北区金閣寺町1",
    postcode: "6038361"
  )

Admin.create!(
    email: "admin@test.com",
    password: "admintest"
  )