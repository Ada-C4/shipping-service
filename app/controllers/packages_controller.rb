class PackagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def rates
    binding.pry
    package = create_package
    origin = ActiveShipping::Location.new(country: 'US',
                                       state: 'CA',
                                       city: 'Beverly Hills',
                                       zip: '90210')

    destination = create_destination(params)
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

  private

  def create_package
    @package = ActiveShipping::Package.new(100, [10, 20, 30], :units => :metric)
  end

  def create_destination(params)
    @destination = ActiveShipping::Location.new(country: params[:destination_address][:country],
                                            state: params[:destination_address][:state],
                                            city: params[:destination_address][:city],
                                            zip: params[:destination_address][:zip])

  end

  # "product[name]=Responsive Web Design with HTML5 and CSS3&product[sku]=1849693188&product[publisher]=Packt Publishing (April 10, 2012)"
  # "destination_address[country]=US&destination_address[state]=WA&destination_address[city]=Seattle&destination_address[98112]"

end
