class Customers::CartItemsController < ApplicationController
  
  def create
    @cart_item = current_customer.cart_items.new(cart_items_params)
    # cart_items_new = current_customer.cart_items.find_by(item_id: @cart_item.item_id)

    # if cart_items_new.nil?
    #   @cart_item.save
    #   redirect_to customers_cart_items_path
    # else
    #   total_quantity = (@cart_item.quantity + cart_items_new.quantity).to_i
    #   cart_items_new.update(:quantity,total_quantity)
    #   @cart_item.destroy
    #   redirect_to customers_cart_items_path

    # end


    # @cart_items = current_customer.cart_items.all

    # @cart_items.each do |cart_item|
    #   if cart_item.item_id == @cart_item.item_id
    #     total_quantity = cart_item.quantity + @cart_item.quantity
    #     cart_item.update(:quantity, total_quantity)
    #     # byebug
    #     @cart_item.destroy
    #   end
    # end
    @cart_item.save
    redirect_to cart_items_path
  end




  def index
    @cart_items = current_customer.cart_items
    @tax = 1.1
  end

  def update
    CartItem.find(params[:id]).update(cart_items_params)
    redirect_to cart_items_path
  end

  def destroy
    CartItem.find(params[:id]).destroy
    redirect_to cart_items_path
  end

  def all_destroy
    current_customer.cart_items.destroy_all
    redirect_to items_path
  end

  private

  def cart_items_params
    params.require(:cart_item).permit(:quantity, :customer_id, :item_id)
  end

end
