require 'httparty'

class PackagesController < ApplicationController
 include Timeout

  def index
    origin = get_origin
    package = get_package
    destination = get_destination(params)

     ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
     usps = ActiveShipping::USPS.new(login: ENV["USPS_LOGIN"])

    ups_response = ups.find_rates(origin, destination, package)
    ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}

    usps_response = usps.find_rates(origin, destination, packages)
    usps_rates = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}

    begin
      Timeout::timeout(10) do
        if ups_rates && usps_rates
          all_rates = ups_rates.concat(usps_rates)
          render :json => all_rates.as_json, :status => :ok
        elsif ups_rates
          render :json => ups_rates.as_json, :status => :partial_content
        elsif usps_rates
          render :json => usps_rates.as_json, :status => :partial_content
        else
          render :json => [], :status => :no_content
        end
      end
    rescue Timeout::Error
      render :json => [], :status => :gateway_timeout
    end
  end
  end
  #
  # def ups_price_estimate
  #
  # end
  #
  # def usps_price_estimate
  #
  # end
  #
  # def ups_delivery_time
  #
  # end
  #
  # def usps_delivery_time
  #
  # end




end
