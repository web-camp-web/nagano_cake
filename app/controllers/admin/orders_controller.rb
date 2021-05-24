class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:customer_id].nil?
      @orders = Order.page(params[:page]).reverse_order
    else
      @orders = Order.where(customer_id: params[:customer_id]).page(params[:page]).reverse_order
    end
  end

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end

  def update
    order = Order.find(params[:id])
    order.update(order_params)
    order.order_item_status_auto_update
    redirect_to admin_order_path(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
