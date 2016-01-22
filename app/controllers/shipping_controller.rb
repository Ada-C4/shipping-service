require 'active_shipping'

class ShippingController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def ups_rates
    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_ACCESS_KEY'])
    ups_rates = get_rates(ups)
    render :json => ups_rates, :status => (ups_rates.flatten.include?("error") ? 204 : 200)
  end

  def usps_rates
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])
    usps_rates = get_rates(usps)
    render :json => usps_rates, :status => (usps_rates.flatten.include?("error") ? 204 : 200)
  end

  private
    def get_rates(carrier)
      destination = location(params["destination"])
      origin = location(params["origin"])
      package = package(params["package"])
      begin
        response = carrier.find_rates(origin, destination, package)
        return response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      rescue ActiveShipping::ResponseError => error
        return [["error"], [error.to_s]]
      end
    end

    def location(loc_hash)
      ActiveShipping::Location.new(loc_hash)
    end

    def package(package_hash)
      weight = package_hash["weight"].to_i
      width = package_hash["width"].to_i
      length = package_hash["length"].to_i
      height = package_hash["height"].to_i
      cylinder = package_hash["cylinder"]
      return ActiveShipping::Package.new(weight, [length, width, height], cylinder: cylinder, units: :imperial)
    end
end
