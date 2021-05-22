class SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == "Item"
      @items = Item.looks(params[:word])
    else
      @customers = Customer.looks(params[:word])
    end
end
