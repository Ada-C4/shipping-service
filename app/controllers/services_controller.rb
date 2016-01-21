class ServicesController < ApplicationController
  ## EXAMPLE
    # params = { packages: [{ dimensions: [25, 10, 15], weight: 500 }, { dimensions: [18, 30, 10], weight: 5000 }], origin: { state: "WA", city: "Seattle", zip: "98101" }, destination: { state: "IL", city: "Vernon Hills", zip: "60061" } }.to_json
    # r = HTTParty.post("http://localhost:3000/ups/", headers: { 'Content-Type' => 'application/json' }, body: params)
    # r = HTTParty.post("http://shipple.herokuapp.com/usps/", headers: { 'Content-Type' => 'application/json' }, body: params)

  def ship
    packages = set_packages
    origin = set_origin
    destination = set_destination

    service = case params[:service]
    when :ups then ups_credentials
    when :usps then usps_credentials
    end

    response = service.find_rates(origin, destination, packages)
    service_rates = response.rates
      .sort_by(&:price)
      .collect do |rate|
        {
          rate: rate.service_name,
          price: rate.price,
          date: rate.delivery_date
        }
      end

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
