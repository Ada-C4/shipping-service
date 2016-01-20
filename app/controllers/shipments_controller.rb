class ShipmentsController < ApplicationController
include ShipmentsHelper
  def estimate
    package = ActiveShipping::Package.new(params)
    packages = [package]
    origin = ActiveShipping::Location.new(params)
    destination = ActiveShipping::Location.new(params)

    ups = ups_rates(origin, destination, pacakages)
    usps = usps_rates(origin, destination, packages)
  end

end
