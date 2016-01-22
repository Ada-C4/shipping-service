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
    # only one package for all products in order, for now
    package = [ActiveShipping::Package.new(OUNCES, DIMENSIONS, units: :imperial, value: params[:value])]
    # destination address info comes from query params provided from betsy app's API call
    destination = ActiveShipping::Location.new(country: COUNTRY, state: params[:destination][:state], city: params[:destination][:city], zip: params[:destination][:zip])
    # method call
    ups_estimates = get_ups_estimates(ORIGIN, destination, package)
    # method call
    fedex_estimates = get_fedex_estimates(ORIGIN, destination, package)
    # response includes rates and dates from both Ups and Fedex
    response = {"UPS Service Options" => ups_estimates, "FedEx Service Options" => fedex_estimates }
    render :json => response.as_json, :status => :ok
  end

private

  def get_ups_estimates(origin, destination, package)
    rates_response = UPS.find_rates(ORIGIN, destination, package)
    delivery_dates_response = UPS.get_delivery_date_estimates(ORIGIN, destination, package)
    # shipping_estimate will be a hash made up of service_code keys
    # each key points to a hash which contains the cost and delivery date estimate
    # for the corresponding service type.
    shipping_estimate = Hash.new
    rates_response.rates.each do |rate|
      # skip this rate if service code is nil
      next if rate.service_code.nil?
      # otherwise, create a key for the corresponding service code
      # the value is a hash containing the corresponding cost
      shipping_estimate["#{rate.service_code}"] = { "cost" => "#{rate.total_price}" }
    end
    delivery_dates_response.delivery_estimates.each do |estimate|
      # skip this estimate if service code is nil
      next if estimate.service_code.nil?
      # otherwise check to see if the service code already exists in the hash
      if shipping_estimate["#{estimate.service_code}"].nil?
        # if the service code doesn't yet exist in the hash, create a key for it
        # with the value being a hash corresponding to the date
        shipping_estimate["#{estimate.service_code}"] = { "date" => "#{estimate.date}" }
      else
        # if it already exists, merge the date corresponding to this estimate into the the
        # hash associated with this service code key
        shipping_estimate["#{estimate.service_code}"].merge!({ "date" => "#{estimate.date}"})
      end
    end
    return shipping_estimate
  end

  def get_fedex_estimates(origin, destination, package)
    #placeholder
    return Hash.new
  end


end
