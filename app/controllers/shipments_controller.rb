class ShipmentsController < ApplicationController

  def shipment
    errors = error_handling(params)
    if errors
      return errors
    else
      origin = ActiveShipping::Location.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210')

      destination = ActiveShipping::Location.new(country: params[:destination][:country], state: params[:destination][:state], city: params[:destination][:city], zip: params[:destination][:zip])
      packages = []
      if !params[:packages].nil?
        params[:packages].each do |package|
          weight = package[:weight]
          dimensions = package[:dimensions].split(",").map!{|string| string.to_i}
          pack = ActiveShipping::Package.new(weight, dimensions)
          packages << pack
        end
          @quotes = get_quotes(origin, destination, packages)
          render :json => @quotes.as_json
      else
        render:json => ["Packages is empty"].as_json, :status => :bad_request
      end
    end
  end

  private

  def get_quotes(origin, destination, packages)
    quotes = []

    ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
    response = ups.find_rates(origin, destination, packages)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    usps = ActiveShipping::USPS.new(login: ENV["ACTIVESHIPPING_USPS_LOGIN"])

    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price ]}

    quotes << ups_rates
    quotes << usps_rates
    return quotes
  end

  def error_handling(params)
    location_keys = ["city", "state", "country", "zip"]
    package_keys = ["weight", "dimensions"]
    proper_packages = true
    if !params.include?("destination")
      render:json => ["You didn't submit a destination."].as_json, :status => :bad_request
    elsif !params.include?("origin")
      render:json => ["You didn't submit an origin."].as_json, :status => :bad_request
    elsif !params.include?("packages")
      render:json => ["You didn't submit your package information."].as_json, :status => :bad_request
    elsif params["destination"].keys() & location_keys != location_keys
      render:json => ["Your destination information is incomplete"].as_json, :status => :bad_request
    elsif params["origin"].keys() & location_keys != location_keys
        render:json => ["Your origin information is incomplete"].as_json, :status => :bad_request
    elsif
      params["packages"].each do |package| 
        proper_packages = false if package.keys & package_keys !=  package_keys
      render:json => ["Your package information is incomplete"].as_json, :status => :bad_request if !proper_packages
      end
    else
      return false
    end
  end

end
