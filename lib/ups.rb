class Ups
  attr_accessor :ups_audit
  
  def initialize
    @ups_audit = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
  end

  def find_rates(shipment_params)
    origin = ActiveShipping::Location.new(country: 'US', state: shipment_params["origin"]["state"], city: shipment_params["origin"]["city"], zip: shipment_params["origin"]["zip"])
    destination = ActiveShipping::Location.new(country: 'US', state: shipment_params["destination"]["state"], city: shipment_params["destination"]["city"], zip: shipment_params["destination"]["zip"])
    packages = ActiveShipping::Package.new(shipment_params["packages"]["weight"], [shipment_params["packages"]["height"], shipment_params["packages"]["width"], shipment_params["packages"]["length"]], :units => :imperial, :currency => "USD")

    response = ups_audit.find_rates(origin, destination, packages)
    rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    return rates
  end
end