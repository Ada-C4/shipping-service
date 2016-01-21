class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  #query ups for prices
  # curl -H "Content-Type: application/json" -X POST --data '{"origin" : { "city" : "Seattle", "state" : "WA", "zip" : "98133" }}' http://localhost:3000/rates

  def get_rates
    origin = ActiveShipping::Location.new(params["origin"])
    # binding.pry
    packages = [ActiveShipping::Package.new(100, [93,10], cylinder: true)]
    ups_get_rates(origin, destination, packages)
    #TODO: separate out carriers
    # if shipper == "ups"
    #   ups_get_rates
    # elsif shipper == "usps"
    #   usps_get_rates
    # end
  end

  def prepare_origin
  end

  def ups_get_rates(origin, destination, packages)
    # destination = ActiveShipping::Location.new(country:, state:, city:, zip:)
    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    response = ups.find_rates(origin, destination, packages)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

  def usps_get_rates(orgin, destination, packages)
    usps = ActiveShipping::USPS.new(:login => ENV['USPS_LOGIN'])
    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

end
