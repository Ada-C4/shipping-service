class ShipmentsController < ApplicationController
  def rates
    ship_json = JSON.parse(params[:json_data])["shipment"]
    ups_rates = Ups.new.find_rates(ship_json)
    usps_rates = Usps.new.find_rates(ship_json)

    shipment_options = ups_rates + usps_rates

    if !shipment_options.empty?
      render json: shipment_options.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render json: [], status: 204
    end
  end
end
