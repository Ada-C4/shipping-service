class ShipmentsController < ApplicationController

  def estimate
    shipment = Shipment.new(shipment_params)
    shipment.get_shipping_cost
    #return both datas as JSON
  end

private

  def shipment_params
    params.require(:shipment).permit(:name, :country, :city, :state, :postal_code, :length, :width, :height, :weight, :cylinder)
  end

end
