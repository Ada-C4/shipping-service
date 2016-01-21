class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates

  def get_quotes
    quotes = []
    ups = ActiveShipping::UPS.new("put login and keys here")
    ups_quote = ups.find_rates(self.origin, self.destination, self.packages)
    fedex = ActiveShipping::FedEx.new("put login and keys here")
    fedex_quote = "get quote from fedex"
    quotes << ups_quote
    quotes << fedex_quote
    return quotes
  end

end
