class EstimatesController < ApplicationController
  include Estimator

  def quote
    QuoteCalulator.query(shipping_params)
  end




private

  def shipping_params
    #params.require().permit()
  end


end
