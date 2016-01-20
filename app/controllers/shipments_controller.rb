class ShipmentsController < ApplicationController

  def shipment
    shipment = Shipment.create(params)
    quotes = []
    ups = ActiveShipping::UPS.new("put login and keys here")
    ups_quote = ups.find_rates(shipment.origin, shipment.destination, shipment.packages)
    fedex = ActiveShipping::FedEx.new("put login and keys here")
    fedex_quote = "get quote from fedex"
    quotes << ups_quote
    quotes << fedex_quote
    # return json info
    # render :json => quotes.as_json
  end
end
