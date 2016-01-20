class ShipmentsController < ApplicationController
  def shipment
    shipment = Shipment.create(params)
    quotes = shipment.get_quotes

    # return json info
    # render :json => quotes.as_json
  end
end
