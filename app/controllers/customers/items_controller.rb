class Customers::ItemsController < ApplicationController

  def index
    @items = Item.page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
    @total_price = (@item.price * 1.1).to_i
    @cart_item = CartItem.new

  end

end
