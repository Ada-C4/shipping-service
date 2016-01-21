class ShipmentsController < ApplicationController
  def shipment
    shipment = Shipment.new

    origin = ActiveShipping::Location.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210')

    destination = ActiveShipping::Location.new(country: params[:destination][:country], state: params[:destination][:state], city: params[:destination][:city], zip: params[:destination][:zip])
    packages = []

    params[:packages].each do |package|
      weight = package[:weight].to_i
      dimensions = package[:dimensions].to_a.map! { |num| num.to_i }

      pack = ActiveShipping::Package.new(weight, dimensions)
      packages << pack
    end

    shipment.save

    quotes = shipment.get_quotes(origin, destination, packages)
    render :json => quotes.as_json
  end

  # private
  #
  # def package_params
  #   params.permit(packages: [:weight, :dimensions])
  # end
end
