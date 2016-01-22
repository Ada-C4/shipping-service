module Estimator
  class Estimate < ActiveRecord::Base
    require 'active_shipping'
    require 'pry'

    def self.query(ship_params)
      #make query in here to get quotes
      quote = {:hi => "how are you"}
      shipment_array = shipment_array(ship_params)
      ups_rates(shipment_array)
      ups_date_estimates(shipment_array)

      return quote
    end

    def self.shipment_array(ship_params)
      #from params, goes through packages and gets each one in the format needed to make the call to active shipping
      #the shipment array is an array of hashes. each hash has a key and the value is an object that can be used by active shipping to make the call to the shipping service
      #notice that because there are multiple package items, each package needs to be packed by calling on the pack_items method
      shipment_array = []
      ship_params[:packages].each do |package|
        package_info = pack_items(package)
        active_origin = ActiveShipping::Location.new(package[:origin])
        active_destination = destination(ship_params)
        active_package = ActiveShipping::Package.new(package_info[:weight], package_info[:dimensions], :units => :imperial, :value => 10) #had to add value for delivery date estimate

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
      # keeping destination as a separate method since that's how params will come in from wetsy.
      #would have been better maybe to keep it more general for our api, so that packages can have any destination. But that's ok.
      ActiveShipping::Location.new(ship_params[:destination])
    end


    def self.ups
      ActiveShipping::UPS.new(login: 'shopifolk', password: 'Shopify_rocks', key: '7CE85DED4C9D07AB')
    end

    def self.ups_rates(shipment_array)
      #ups_rates is an array of hashes with different shipping services and their cost.
      #total_ups_rates creates as array summing the cost of each of the packages for the same service
      #this is where are are taking all the packages from each different merchant and summing their shipping costs
      ups_rates = []
        shipment_array.each do |shipment|
            response = ups.find_rates(shipment[:origin], shipment[:destination], shipment[:package])
            sorted_rates = (response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}).to_h
            ups_rates << sorted_rates
        end

      total_ups_rates = Hash.new(0)
      ups_rates.each { |subhash| subhash.each { |service, cost| total_ups_rates[service] += cost } }
      return total_ups_rates
    end

    #takes shipments and estimates delivery dates. End up returning the least optimistic set of dates to the user. So they might be ordering from many merchants, and they see the date for the item that will arrive the slowest
    def self.ups_date_estimates(shipment_array)
      ups_date_estimates = []
      shipment_array.each do |shipment|
        response = ups.get_delivery_date_estimates(shipment[:origin], shipment[:destination], shipment[:package], pickup_date = Date.current, options = {})
        sorted_dates = (response.delivery_estimates.sort_by(&:date).collect {|est| [est.service_name, est.date]}).to_h
        ups_date_estimates << sorted_dates
      end
      #take date estimates and for each service, find the least optimistic date
      ups_date_estimates
    end



    def usps_rates
      usps = USPS.new(login: 'your usps account number', password: 'your usps password')
      get_rates_from_shipper(usps)
    end
  end
end
