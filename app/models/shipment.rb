class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates

  def get_quotes(origin, destination, packages)
    quotes = []

    ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])

    ups_quote = ups.find_rates(origin, destination, packages)

    usps = ActiveShipping::USPS.new(login: ENV["ACTIVESHIPPING_USPS_LOGIN"])
    # binding.pry
    usps_quote = usps.find_rates(origin, destination, packages)

    # make estimate from eachquote, use regex to pull FEDEX out of string"
    quotes << ups_quote
    quotes << usps_quote
    return quotes
  end

end
