require 'httparty'

class PackagesController < ApplicationController
 # include Timeout

  def rates
    origin = get_origin
    package = get_package
    destination = get_destination

     ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
     usps = ActiveShipping::USPS.new(login: ENV["USPS_LOGIN"])

    ups_response = ups.find_rates(origin, destination, package)
    ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}

    usps_response = usps.find_rates(origin, destination, package)
    usps_rates = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}

    all_rates = { ups: ups_rates, usps: usps_rates }


    # begin
    #   Timeout::timeout(10) do
        if ups_rates && usps_rates
          render :json => all_rates.as_json, :status => :ok
        elsif ups_rates
          render :json => ups_rates.as_json, :status => :partial_content
        elsif usps_rates
          render :json => usps_rates.as_json, :status => :partial_content
        else
          render json: { error: :missing_destination_state, message: "You must provide a valid State for the shipping destination." }, status: :bad_request
        end
      # end
    # rescue Timeout::Error
    #   render :json => [], :status => :gateway_timeout
    # end

  end
  private

  def get_package
    package = [
      ActiveShipping::Package.new(100,
                                  [20,20],
                                  value: 1000)
              ]

    return package
  end

  def get_origin
    origin = ActiveShipping::Location.new(country: 'US',
                                      state: 'WA',
                                      city: 'Seattle',
                                      zip: 98122)
    return origin
  end

  def get_destination
    destination = ActiveShipping::Location.new(
          country: 'US',
          state: params[:state],
          city: params[:city],
          zip: params[:zip])

    return destination
  end




end
