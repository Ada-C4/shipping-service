class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates

  def origin(origin_params)
    Location.find_or_create_by(origin_params)
  end

  def destination(destination_params)
    Location.find_or_create_by(destination_params)
  end

  def get_quotes
    quotes = []
    ups = ActiveShipping::UPS.new("put login and keys here")
    ups_quote = ups.find_rates(self.origin, self.destination, self.packages)
    # make an estimate from each quote, using REGEX to pull UPS out of the string
    fedex = ActiveShipping::FedEx.new("put login and keys here")
    fedex_quote = "get quote from fedex"
    # make estimate from eachquote, use regex to pull FEDEX out of string"
    quotes << ups_quote
    quotes << fedex_quote
    return quotes
  end

end
