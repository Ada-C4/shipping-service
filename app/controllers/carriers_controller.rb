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
    # get a UPS response
    # sort/collect the response

    # set up USPS with credentials
    # get a USPS response
    # sort/collect the response


  end


end
