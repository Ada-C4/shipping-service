module Estimator

  class QuoteCalculator < ActiveRecord::Base
  include ActiveMerchant::Shipping


    def self.query()
      #make query in here to get quotes
    end


  end





end
