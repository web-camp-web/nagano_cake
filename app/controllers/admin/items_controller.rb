class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @item = Item.new
    @genres = Genre.all
  end

  def create
    @item = Item.new(params_item)
    @item.save
    redirect_to admin_items_path
  end

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
    @genres = Genre.all
  end

  def update
    Item.find(params[:id]).update(params_item)
    redirect_to admin_items_path
  end

  private

  def params_item
    params.require(:item).permit(:name, :caption, :price, :genre_id, :is_active, :image)
  end
end
