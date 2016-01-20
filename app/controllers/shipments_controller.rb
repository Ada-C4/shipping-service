class ShipmentsController < ApplicationController

def shipment
  shipment = Shipment.new
  origin = Location.new(params[:origin])
  destination = Location.new(params[:destination])
  packages = params[:packages].each do |package|
    Package.new(package)
  end
  quotes = []
  ups = ActiveShipping::UPS.new()
  ups_quote = ups.find_rates(origin, destination, packages)
  fedex = ActiveShipping::FedEx.new()
  fedex_quote = "get quote from fedex"
  quotes << ups_quote
  quotes << fedex_quote
  # return json info
  # render :json => quotes.as_json
end

end
