class Customers::CartItemsController < ApplicationController
  before_action :authenticate_customer!


  def create
    @cart_item = CartItem.new(cart_items_params)
    @cart_item.customer_id = current_customer.id
    cart_items_new = current_customer.cart_items.find_by(item_id: @cart_item.item_id)


    if cart_items_new.nil?
      if @cart_item.save
        flash[:text] = "カートに追加しました"
        redirect_to cart_items_path
      else
        @item = Item.find_by(id: @cart_item.item_id)
        @total_price = (@cart_item.item.price * 1.1).to_i
        render template: 'customers/items/show'
      end
    else
      # 商品名が同じ場合、数量を合計値にする
      if @cart_item.save
        total_quantity = (@cart_item.quantity + cart_items_new.quantity).to_i
        cart_items_new.update(quantity: total_quantity)
        flash[:text] = "カートに追加しました"
        @cart_item.destroy
        redirect_to cart_items_path
      else
        @item = Item.find_by(id: @cart_item.item_id)
        @total_price = (@cart_item.item.price * 1.1).to_i
        render template: 'customers/items/show'
      end
    end
  end

  def index
    @cart_items = current_customer.cart_items
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_items_params)
    flash[:text] = "数量を変更しました"
    redirect_to cart_items_path
  end

  def destroy
    CartItem.find(params[:id]).destroy
    flash[:text] = "商品を削除しました"
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
