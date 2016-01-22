require 'timeout'

class CarriersController < ApplicationController
  def index
    ### sample params ###
    # {"origin"=>{:country=>"US", :state=>"CA", :city=>"Beverly Hills", :zip=>"90210"},"destination"=>{:country=>"US", :state=>"WA", :city=>"Seattle", :zip=>"98103"},"packages"=>[{:weight=>100, :height=>50, :length=>20, :width=>30}]}

    # create ActiveShipping Locations and Packages
    
    # origin = Carrier.create_origin(params[:origin])
    # destination = Carrier.create_destination(params[:destination])
    # packages = Carrier.create_packages(params[:packages]) # as an array
    #
    #
    # @ups_rates = begin
    #   Carrier.get_rates(Carrier.activate_ups, origin, destination, packages)
    # rescue Timeout::Error
    #   nil
    # end
    #
    # @usps_rates = begin
    #   Carrier.get_rates(Carrier.activate_usps, origin, destination, packages)
    # rescue Timeout::Error
    #   nil
    # end

    @ups_rates, @usps_rates = Carrier.get_rates(params)


    # examine the rates for errors and turn this into JSON
    # as long as it takes less than 5 seconds
    if @ups_rates && @usps_rates
      all_rates = @ups_rates.concat(@usps_rates)
      render :json => all_rates.as_json, :status => :ok
    elsif @ups_rates
      render :json => @ups_rates.as_json, :status => :ok
    elsif @usps_rates
      render :json => @usps_rates.as_json, :status => :ok
    else
      render :json => [], :status => :no_content
    end
  end
end
