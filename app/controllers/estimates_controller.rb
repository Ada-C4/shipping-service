class EstimatesController < ApplicationController
  include Estimator
  
  def ups_estimate
    ups = ActiveShipping::UPS.new(login: 'auntjudy', password: 'secret', key: 'xml-access-key')
    response = ups.find_rates(origin, destination, packages)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
    render :json => response.as_json, :status => :ok
  end



end
