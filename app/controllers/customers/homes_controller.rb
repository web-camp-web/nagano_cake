class Customers::HomesController < ApplicationController
  def top
    @items = Item.all.order(updated_at: :desc).limit(4)
  end

  def about
  end
end
