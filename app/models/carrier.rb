require 'timeout'

class Carrier

  def self.get_rates(params)
    origin = Carrier.create_origin(params[:origin])
    destination = Carrier.create_destination(params[:destination])
    packages = Carrier.create_packages(params[:packages])

    ups_rates = begin
      Timeout::timeout(5) do
        response = Carrier.activate_ups.find_rates(origin, destination, packages)
        response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}
      end
    rescue Timeout::Error
      nil
    end

    usps_rates = begin
      Timeout::timeout(5) do
        response = Carrier.activate_usps.find_rates(origin, destination, packages)
        response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}
      end
    rescue Timeout::Error
      nil
    end
    return ups_rates, usps_rates
  end

  def self.create_origin(origin_params)
    ActiveShipping::Location.new(
      country:  origin_params[:country],
      state:    origin_params[:state],
      city:     origin_params[:city],
      zip:      origin_params[:zip])
  end

  def self.create_destination(destination_params)
    ActiveShipping::Location.new(
      country:  destination_params[:country],
      state:    destination_params[:state],
      city:     destination_params[:city],
      zip:      destination_params[:zip])
  end

  def self.create_packages(package_params)
    packages = []
    package_params.each do |package|
      p = ActiveShipping::Package.new(
        package[:weight].to_i,
        [
          package[:length].to_i,
          package[:width].to_i,
          package[:height].to_i
        ]
      )
      packages.push(p)
    end
    return packages
  end

  def self.activate_ups
    ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PW"], key: ENV['UPS_ACCESS_KEY'])
  end

  def self.activate_usps
    ActiveShipping::USPS.new(login: ENV["USPS_ACCESS_KEY"])
  end
end
