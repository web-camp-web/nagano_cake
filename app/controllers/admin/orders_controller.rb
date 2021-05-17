class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.page(params[:page]).reverse_order
  end

  def show
  end
end
