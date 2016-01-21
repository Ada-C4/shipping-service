module Estimator
  class Estimate < ActiveRecord::Base
    require 'active_shipping'
    require 'pry'

    def self.query(ship_params)
      #make query in here to get quotes
      quote = {:hi => "how are you"}
      dest = destination(ship_params)
      shipment_array(ship_params)
      return quote
    end

    def self.shipment_array(ship_params)
      # Location.new(country: "US", state: "CA", city: "Los Angeles", postal_code: "90001")
      #from params, goes through packages and gets each one in the format needed to make the call to active shipping
      #the shipment array is an array of hashes. each hash has a key and the value is an object that can be used by active shipping to make the call to the shipping service
      #notice that because there are multiple package items, each package needs to be packed by calling on the pack_items method
      shipment_array = []
      ship_params[:packages].each do |package|
        package_info = pack_items(package)
        active_origin = ActiveShipping::Location.new(package[:origin])
        active_destination = destination(ship_params)
        active_package = ActiveShipping::Package.new(package_info[:weight], package_info[:dimensions], :units => :imperial)

        package_hash = {origin: active_origin,
                        destination: active_destination,
                        package: active_package
                        }
        shipment_array << package_hash
      end
      return shipment_array
    end

    def self.pack_items(package)
      #different items from the same merchant will be packed together into one package
      #a simple way to do this is to find the longest length and and add together the widths and heights. return the total weight and the dimensions of this package.
      #this method assumes the length is the longest dimension
      weight = package[:package_items].map {|item| item[:weight].to_i}.sum
      longest_package = package[:package_items].max_by{|item| item[:length]}
      length = longest_package[:length].to_i
      width = package[:package_items].map {|item| item[:width].to_i}.sum
      height =  package[:package_items].map {|item| item[:height].to_i}.sum
      package_info = {weight: weight, dimensions: [length, width, height]}
      return package_info
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
