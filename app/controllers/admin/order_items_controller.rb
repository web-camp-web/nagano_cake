class Admin::OrderItemsController < ApplicationController
  before_action :authenticate_admin!

  def update
    order_item = OrderItem.find(params[:id])
    order = order_item.order
    if order.status != "入金待ち"
      order_item.update(order_item_params)
      order_item.order_status_auto_update
      order_item.product_complete_auto_update
      redirect_to admin_order_path(order)
    else
      flash[:order_status_error] = "注文ステータスが「入金待ち」の為、変更できません"
      redirect_to admin_order_path(order)
    end
  end

    private

  def order_item_params
    params.require(:order_item).permit(:product_status)
  end
end
