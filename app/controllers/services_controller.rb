class ServicesController < ApplicationController
  ## EXAMPLE
    # params = { packages: [{ dimensions: [20, 10, 5], weight: 50 }, { dimensions: [15, 5, 10], weight: 25 }], origin: { state: "WA", city: "Seattle", zip: "98101" }, destination: { state: "IL", city: "Vernon Hills", zip: "60061" } }.to_json
    # r = HTTParty.post("http://localhost:3000/ups", headers: { 'Content-Type' => 'application/json' }, body: params)

  def ship
    packages = set_packages
    origin = set_origin
    destination = set_destination

    service = case params[:service]
    when :ups then ups_credentials
    when :usps then usps_credentials
    end

    response = service.find_rates(origin, destination, packages)
    service_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}
    data_hash = { data: service_rates }

    render :json => data_hash.as_json, :status => :ok
  end

  private

  def usps_credentials
    ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])
  end

  def ups_credentials
    ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
  end
end
