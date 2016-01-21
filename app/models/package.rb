class Package < ActiveRecord::Base

  def get_package
    package = [
      ActiveShipping::Package.new(100,
                                  [100,100],
                                  valule: 10000)
              ]

    return package
  end

  def get_origin
    origin = ActiveShipping::UPS.new(country: 'US',
                                      state: 'WA',
                                      city: 'Seattle',
                                      zip: 98122)
    return origin
  end

end
