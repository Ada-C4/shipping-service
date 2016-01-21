class CarriersController < ApplicationController
  include Timeout

  def index
    ### sample params ###
    # {"origin"=>{:country=>"US", :state=>"CA", :city=>"Beverly Hills", :zip=>"90210"},"destination"=>{:country=>"US", :state=>"WA", :city=>"Seattle", :zip=>"98103"},"packages"=>[{:weight=>100, :height=>50, :length=>20, :width=>30}]}

    # create a new ActiveShipping Location with origin params
    origin = Carrier.create_origin(params[:origin])

    # create a new ActiveShipping Location with destination params
    destination = Carrier.create_destination(params[:destination])

    # create an array of ActiveShipping Package objects with package params
    packages = Carrier.create_packages(params[:packages]) # as an array

    # set up UPS with credentials, get response and sort
    ups = Carrier.activate_ups
    response = ups.find_rates(origin, destination, packages)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]} # could add other fields

    # set up USPS with credentials, get response and sort
    usps = Carrier.activate_usps
    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}

    # examine the rates for errors and turn this into JSON
    # as long as it takes less than 5 seconds
    begin
      Timeout::timeout(5) do
        if ups_rates && usps_rates
          all_rates = ups_rates.concat(usps_rates)
          render :json => all_rates.as_json, :status => :ok
        elsif ups_rates
          render :json => ups_rates.as_json, :status => :partial_content
        elsif usps_rates
          render :json => usps_rates.as_json, :status => :partial_content
        else
          render :json => [], :status => :no_content
        end
      end
    rescue Timeout::Error
      render :json => [], :status => :gateway_timeout
    end
  end
end
