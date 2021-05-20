class Customers::OrdersController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_customer!

  def new
    @order = Order.new
    @my_postcode = current_customer.postcode
    @my_address = current_customer.address
    @deliveries = Delivery.where(customer_id: current_customer.id)

    if current_customer.cart_items.empty?
      redirect_to cart_items_path
    end
  end

  def confirm
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @order = Order.new(order_params)

    address = params[:order][:delivery_address]
    case address
    when "自宅"
      @order.delivery_postcode = current_customer.postcode
      @order.delivery_address = current_customer.address
      @order.delivery_name = customer_full_name(current_customer.id)
    when "登録済住所"
      delivery_id = params[:order][:delivery_address_id]
      delivery = Delivery.find_by(id: delivery_id)
      @order.delivery_postcode = delivery.postcode
      @order.delivery_address = delivery.address
      @order.delivery_name = delivery.name
    when "新しい届け先"
      @order.delivery_postcode = params[:order][:new_postcode]
      @order.delivery_address = params[:order][:new_address]
      @order.delivery_name = params[:order][:new_name]
      delivery = Delivery.new
      delivery.customer_id = current_customer.id
      delivery.postcode = params[:order][:new_postcode]
      delivery.address = params[:order][:new_address]
      delivery.name = params[:order][:new_name]
      delivery.save
    end
  end

  def create
    order = Order.create(order_params)

    current_customer.cart_items.each do |cart_item|

      OrderItem.create(
        order_id: order.id,
        item_id: cart_item.item_id,
        quantity: cart_item.quantity,
        market_price: cart_item.item.price
        )

      cart_item.destroy

    end

    redirect_to orders_complete_path
  end

  def complete
  end

  def show
    @order = Order.find_by(id: params[:id])
    @order_items = @order.order_items
    if (@order.customer != current_customer) && @order.blank?
      redirect_to root_path
    end
  end

  def index
    @orders = current_customer.orders
  end

  private

  def order_params
   params.require(:order).permit(:customer_id, :postage, :total_price, :payment_method, :status,
                                 :delivery_name, :delivery_postcode, :delivery_address)
  end
end
