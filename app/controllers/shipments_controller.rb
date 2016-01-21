class ShipmentsController < ApplicationController
  def shipment
    shipment = Shipment.new

    origin = Location.find_or_create_by(params[:origin])
    destination = Location.find_or_create_by(params[:destination])
    packages = []

    package_params[:packages].each do |package|
      pack = Package.create(package)
      packages << pack
    end

    shipment.save

    quotes = shipment.get_quotes(origin, destination, packages)
    render :json => quotes.as_json
  end

  private

  def package_params
    params.permit(packages: [:weight, :dimensions])
  end
end
