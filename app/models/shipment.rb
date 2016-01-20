class Shipment < ActiveRecord::Base

  def package
  end

  def origin
  end

  def destination
  end

  def USPS_shipping_cost(package, origin, destination)
    #call USPS api and get data
  end

  def UPS_shipping_cost(package, origin, destination)
    #call UPS api and get data
  end

  def shipping_cost(USPS_shipping_cost, UPS_shipping_cost)
    #combine data and format to JSON
  end
end
