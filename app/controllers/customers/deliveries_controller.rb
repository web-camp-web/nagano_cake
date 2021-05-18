class Customers::DeliveriesController < ApplicationController

  def index
    @delivery = Delivery.new
    @deliveries = current_customer.deliveries
  end

  def create
    @delivery = Delivery.new(delivery_params)
    @delivery.customer_id = current_customer.id
    if @delivery.save
      redirect_back(fallback_location: root_path)
    else
      @deliveries = current_customer.deliveries
      render :index
    end
  end

  def destroy
    @delivery = current_customer.deliveries.find(params[:id])
    @delivery.destroy
    redirect_to deliveries_path
  end

  def edit
    @delivery = current_customer.deliveries.find(params[:id])
  end

  def update
    @delivery = current_customer.deliveries.find(params[:id])
    if @delivery.update(delivery_params)
      redirect_to deliveries_path
    else
      render :edit
    end
  end

  private

    def delivery_params
      params.require(:delivery).permit(:postcode, :address, :name)
    end
end
