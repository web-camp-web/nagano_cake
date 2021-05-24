FactoryBot.define do
  factory :order_item do
    item_id { 1 }
    order_id { 1 }
    quantity { 1 }
    market_price { Item.find(1).price }
  end
end