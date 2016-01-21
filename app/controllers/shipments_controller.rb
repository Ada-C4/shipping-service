class ShipmentsController < ApplicationController
  def shipment
    shipment = Shipment.new

    origin = shipment.origin(params[:origin])
    destination = shipment.destination(params[:destination])
    packages = []

    package_params[:packages].each do |package|
      pack = Package.create(package)
      packages << pack
    end

    shipment.save

    quotes = shipment.get_quotes
    render :json => quotes.as_json
  end

  private

  def package_params
    params.permit(packages: [:weight, :dimensions])
  end
end
