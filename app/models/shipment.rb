class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates

  def get_quotes(origin, destination, packages)
    quotes = []

    ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
    ups_quote = ups.find_rates(origin, destination, packages)

    fedex = ActiveShipping::FedEx.new(login: ENV[""], password: ENV[""], key: ENV["FEDEX_DEVELOPER_TEST_KEY"], account: ENV["FEDEX_TEST_ACCOUNT_NUMBER"])
    fedex_quote = fedex.find_rates(origin, destination, packages)
    
    # make estimate from eachquote, use regex to pull FEDEX out of string"
    quotes << ups_quote
    quotes << fedex_quote
    return quotes
  end

end
