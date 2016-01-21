class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates

  def get_quotes(origin, destination, packages)
    quotes = []
    ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
    binding.pry
    ups_quote = ups.find_rates(origin, destination, packages)
    # make an estimate from each quote, using REGEX to pull UPS out of the string
    
    # fedex = ActiveShipping::FedEx.new(login: '999999999', password: '7777777', key: '1BXXXXXXXXXxrcB', account: '51XXXXX20')
    fedex = ActiveShipping::FedEx.new("put login and keys here")
    fedex_quote = "get quote from fedex"
    # make estimate from eachquote, use regex to pull FEDEX out of string"
    quotes << ups_quote
    quotes << fedex_quote
    return quotes
  end

end
