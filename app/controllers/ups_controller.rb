class UpsController < ApplicationController
  def index
    packages = []
    params[:packages].each do |package|
      packages << ActiveShipping::Package.new(package[:weight], package[:dimensions])
    end

    # packages = [
    #   ActiveShipping::Package.new(100, [93,10]),
    #   ActiveShipping::Package.new(7.5 * 16, [15, 10, 4.5])]

    origin = ActiveShipping::Location.new(country: 'US', state: origin[:state], city: origin[:city], zip: origin[:zip])
    # origin = ActiveShipping::Location.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210')

    destination = ActiveShipping::Location.new(country: 'US', state: destination[:state], city: destination[:city], zip: destination[:zip])
    # destination = ActiveShipping::Location.new(country: 'CA',
    #               province: 'ON',
    #               city: 'Ottawa',
    #               postal_code: 'K1P 1J1')

    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])

    response = ups.find_rates(origin, destination, packages)

    # service_name, price, delivery_range, delivery_date
    ups_rates = response.rates
    data_hash = { data: ups_rates }

    render :json => data_hash.as_json, :status => :ok
    # render some json
    # render :json => thingreturnedfromups  :status => :ok
  end
end
