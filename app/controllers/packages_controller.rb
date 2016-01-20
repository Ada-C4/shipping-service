class PackagesController < ApplicationController

  def rates
    weight = params[:order_item][:product][:weight]

    # "order_item":{"product":{"weight": "500"}}
    package = ActiveShipping::Package.new(weight, [10, 20, 30], :units => :metric)
    origin = ActiveShipping::Location.new(country: 'US',
                                       state: 'CA',
                                       city: 'Beverly Hills',
                                       zip: '90210')

    destination = ActiveShipping::Location.new(country: 'CA',
                                            province: 'ON',
                                            city: 'Ottawa',
                                            postal_code: 'K1P 1J1')

    # Verified USPS works
    usps = ActiveShipping::USPS.new(login: ENV["USPS_USERNAME"], password: ENV["USPS_PASSWORD"])
    response = usps.find_rates(origin, destination, package)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # Verified UPS works
    ups = ActiveShipping::UPS.new(login: ENV["UPS_ACCOUNT_NAME"], password: ENV["UPS_ACCOUNT_PASSWORD"], key: ENV["UPS_ACCESS_KEY"])
    response = ups.find_rates(origin, destination, package)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    all_rates = { ups: ups_rates, usps: usps_rates }
    render :json => all_rates.as_json

    # fedex = ActiveShipping::FedEx.new(login: ENV["FEDEX_ACCOUNT_NAME"], password: ENV["FEDEX_ACCOUNT_PASSWORD"], key: ENV["FEDEX_TEST_KEY"], account: ENV["FEDEX_TEST_ACCOUNT_NUMBER"])
    # response = fedex.find_rates(origin, destination, package)
    # fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}


  end
end
