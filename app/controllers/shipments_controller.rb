class ShipmentsController < ApplicationController
  def shipment
    shipment = Shipment.new

    shipment.origin = Location.find_or_create_by(params[:origin])
    shipment.destination = Location.find_or_create_by(params[:destination])
    shipment.packages = []

    package_params.each do |package|
      pack = Package.create(package)
      @packages << pack
    end

    quotes = shipment.get_quotes
    render :json => quotes.as_json
  end

  private

  def package_params
    params.permit(packages: [:weight, :dimensions])
  end
end
