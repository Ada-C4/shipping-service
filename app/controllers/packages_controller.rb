class PackagesController < ApplicationController

  def rates
    package = ActiveShipping::Package.new(100, [10, 20, 30], :units => :metric)
    origin = ActiveShipping::Location.new(country: 'US',
                                       state: 'CA',
                                       city: 'Beverly Hills',
                                       zip: '90210')

    destination = ActiveShipping::Location.new(country: 'CA',
                                            province: 'ON',
                                            city: 'Ottawa',
                                            postal_code: 'K1P 1J1')
  end
end
