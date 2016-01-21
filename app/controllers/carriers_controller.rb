class CarriersController < ApplicationController
  def index
    ### sample params ###
    # {"origin"=>{:country=>"US", :state=>"CA", :city=>"Beverly Hills", :zip=>"90210"},"destination"=>{:country=>"US", :state=>"WA", :city=>"Seattle", :zip=>"98103"},"packages"=>[{:weight=>100, :height=>50, :length=>20, :width=>30}]}

    # create a new ActiveShipping Location with origin params
    origin = Carrier.create_origin(params[:origin])

    # create a new ActiveShipping Location with destination params
    destination = Carrier.create_destination(params[:destination])

    # create an array of ActiveShipping Package objects with package params
    packages = Carrier.create_packages(params[:packages]) # as an array

    # set up UPS with credentials
    ups = Carrier.activate_ups

    # get a UPS response
    response = ups.find_rates(origin, destination, packages)

    # sort/collect the response
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # to do : turn this into JSON


    # set up USPS with credentials
    usps = Carrier.activate_usps

    # get a USPS response
    response = usps.find_rates(origin, destination, packages)

    # sort/collect the response
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # turn this into JSON

  end


end
