# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |n|
  Customer.create!(
    email: "customer#{n + 1}@test.com",
    first_name: "一郎",
    last_name: "サンプル#{n + 1}",
    first_name_kana: "イチロウ",
    last_name_kana: "サンプル#{n + 1}",
    password: "customer#{n + 1}",
    postcode: "1310045",
    address: "東京都墨田区押上1丁目1−12 長野ヒルズ#{n + 1}01号室",
    phone_number: "09012345678"
  )
end

10.times do |n|
  Delivery.create!(
    customer_id: n + 1,
    name: "鈴木花子",
    address: "京都府京都市北区金閣寺町1 京都ハイツ#{n + 1}01号室",
    postcode: "6038361"
  )
end

Admin.create!(
    email: ENV['admin_mail'],
    password: ENV['admin_psw']
  )

Genre.create!(
    name: "ケーキ"
  )

Genre.create!(
    name: "プリン"
  )

Genre.create!(
    name: "焼き菓子"
  )

Genre.create!(
    name: "キャンディ"
  )

Item.create!(
    name: "ショコラケーキ",
    caption: "ベルギー直輸入のチョコレートを贅沢に使用した、大人の味わいが楽しめる一品。",
    price: "800",
    genre_id: 1,
    image: open("./app/assets/images/items/choco_cake.jpg")
  )

Item.create!(
    name: "ガトーショコラ(ホール)",
    caption: "長年愛されてきた定番の一品。濃厚な味わいがあなたを非日常へ誘います。",
    price: "3000",
    genre_id: 1,
    image: open("./app/assets/images/items/gateau_chocolat.jpg")
  )

Item.create!(
    name: "クレームカラメル",
    caption: "ビターカラメルと新鮮なクリームが織りなすハーモニーが楽しめる一品。",
    price: "600",
    genre_id: 2,
    image: open("./app/assets/images/items/creme-caramel.jpg")
  )

Item.create!(
    name: "バニラとベリーのプディング",
    caption: "バニラの風味とベリーの酸味を存分に活かした自信の一品。",
    price: "800",
    genre_id: 2,
    image: open("./app/assets/images/items/pudding.jpg")
  )

Item.create!(
    name: "フレンチシュークリーム",
    caption: "本場フランスのシェフが作る、老若男女問わず愛される王道の一品。",
    price: "400",
    genre_id: 3,
    image: open("./app/assets/images/items/cream-puffs.jpg")
  )

Item.create!(
    name: "くるみのカップケーキ",
    caption: "「究極のアンチエイジングナッツ」と称される、くるみ本来の風味が際立つ一品・",
    price: "700",
    genre_id: 3,
    image: open("./app/assets/images/items/cupcake.jpg")
  )

Item.create!(
    name: "ロリポップキャンディ",
    caption: "季節によってデザインが異なる、お子様に大人気の一品(マグカップ付き)。",
    price: "800",
    genre_id: 4,
    image: open("./app/assets/images/items/lollipop.jpg")
  )

Item.create!(
    name: "ジュエリーキャンディ",
    caption: "ミシュラン三星シェフが「これは飴ではなく宝石だ」と絶賛した至高の一品。",
    price: "600",
    genre_id: 4,
    image: open("./app/assets/images/items/candies.jpg")
  )