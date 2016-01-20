class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates
  attr_reader :origin, :destination, :packages

  def initialize(hash)
    @origin = Location.new(params[:origin])
    @destination = Location.new(params[:destination])
    @packages = []
    params[:packages].each { |package| @packages << Package.new(package) }
  end

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
