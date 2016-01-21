module Estimator
  class Estimate < ActiveRecord::Base
    require 'active_shipping'
    require 'pry'

    def self.query(ship_params)
      #make query in here to get quotes
      quote = {:hi => "how are you"}
      dest = destination(ship_params)
      return quote
    end

    def self.origins_array
      # Location.new(country: "US", state: "CA", city: "Los Angeles", postal_code: "90001")
      #rough draft- may need helpers for params
      #in wetsy, we will get this from the "merchant"
      #make an array of origins to iterate through
        Location.new(shipping_params)
    end

    def self.destination(ship_params)
      # Location.new(country: country, state: state, city: city, postal_code: postal_code)
      #in wetsy this will come from the "order"
      ActiveShipping::Location.new(ship_params[:destination])
    end

    def packages
      #ideally, wetsy combines multiple items from the same merchant into one package
      #each merchant therefore sends just one package
      #we WILL have multiple packages per estimate
      package = Package.new(weight, [length, width, height])
    end

    def get_rates_from_shipper(shipper)
      response = shipper.find_rates(origin, destination, packages)
      response.rates.sort_by(&:price)
    end

    def ups_rates
      ups = UPS.new(login: 'your ups login', password: 'your ups password', key: 'your ups xml key')
      get_rates_from_shipper(ups)
    end

    def fedex_rates
      fedex = FedEx.new(login: "your fedex login", password: "your fedex password", key: "your fedex key", account: "your fedex account number")
      get_rates_from_shipper(fedex)
    end

    def usps_rates
      usps = USPS.new(login: 'your usps account number', password: 'your usps password')
      get_rates_from_shipper(usps)
    end
  end
end
