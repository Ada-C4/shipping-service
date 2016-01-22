require 'active_shipping'

class EstimatesController < ApplicationController
  # create constants for origin object, package grams_or_ounces and package dimensions, and country
  # also create carrier constants which is a ups carrier and a fedex carrier?
  UPS = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])

  FEDEX = ActiveShipping::FedEx.new(login: 'FEDEX_LOGIN', password: 'FEDEX_PASSWORD', key: 'FEDEX_KEY', account: 'FEDEX_ACCOUNT', test: true)

  # assume all packages are being sent within the US
  COUNTRY = "US"
  # assume all packages are originating from Ada's betsy distribution center
  ORIGIN = ActiveShipping::Location.new(country: COUNTRY, state: 'WA', city: 'Seattle', zip: '98101')
  # assume all packages have the same ounces and dimensions, for now
  OUNCES = 120
  DIMENSIONS = [15, 10, 4.5]

  def estimate
    # assume carrier is ups for now
    # only one package for all products, for now
      package = [ActiveShipping::Package.new(OUNCES, DIMENSIONS, units: :imperial, value: params[:value])]
    # destination address info comes from query params provided from betsy app's API call
      destination = ActiveShipping::Location.new(country: COUNTRY, state: params[:destination][:state], city: params[:destination][:city], zip: params[:destination][:zip])


      rates_response = UPS.find_rates(ORIGIN, destination, package)
      delivery_dates_response = UPS.get_delivery_date_estimates(ORIGIN, destination, package)

      # need to filter above responses down to the data we want (cost, date, service code)
      # also need to remove any results with nil for service code
      response = [rates_response.rates.first, delivery_dates_response.delivery_estimates.first]

    render :json => response.as_json, :status => :ok
  end
end
