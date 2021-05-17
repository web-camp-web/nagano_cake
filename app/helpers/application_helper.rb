module ApplicationHelper
  def postage
    800
  end

  #現状は軽減税率対象品のみのため消費税8％
  def tax
    0.08
  end

  def customer_full_name(customer_id)
    customer = Customer.find_by(id: customer_id)
    customer.last_name + customer.first_name
  end

  def customer_full_address(customer_id)
    customer = Customer.find_by(id: customer_id)
    "#{customer.postcode} " + customer.address
  end

  def tax_price(item_id)
    market_price = Item.find_by(id: item_id).price
    ( market_price * (1 + tax) ).floor
  end

  def sub_price(cart_item_id)
    cart_item = CartItem.find_by(id: cart_item_id)
    tax_price(cart_item.item_id) * cart_item.quantity
  end

  def cart_items_total_price(customer_id)
    price = 0
    cart_items = CartItem.where(customer_id: customer_id)
    cart_items.each do |cart_item|
      price  +=  sub_price(cart_item.id)
    end
    return price
  end

  def billing(customer_id)
    cart_items_total_price(customer_id) + postage
  end

end
