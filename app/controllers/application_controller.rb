class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token


  #query ups for prices
  # curl -H "Content-Type: application/json" -X POST --data '{"origin" : { "city" : "Seattle", "state" : "WA", "zip" : "98133" }, "packages" : { }}' http://localhost:3000/rates

  def get_rates
    origin = ActiveShipping::Location.new(country: 'US',
                                           state: 'CA',
                                           city: 'Beverly Hills',
                                           zip: '90210')
    destination = ActiveShipping::Location.new(params["destination"])
    packages = ActiveShipping::Package.new(100, [93,10], cylinder: true)
    ups_rates = ups_get_rates(origin, destination, packages)
    usps_rates = usps_get_rates(origin, destination, packages)
    rates = { ups: ups_rates, usps: usps_rates }
    render :json => rates.as_json, :status => :ok
  end

  def prepare_origin
  end

  def ups_get_rates(origin, destination, packages)
    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'], origin_name: ENV['UPS_ORIGIN_NAME'], origin_account: ENV['UPS_ORIGIN_ACCOUNT'] )
    response = ups.find_rates(origin, destination, packages)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return ups_rates
  end

  def usps_get_rates(origin, destination, packages)
    usps = ActiveShipping::USPS.new(:login => ENV['USPS_LOGIN'])
    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return usps_rates
  end

end
