class EstimatesController < ApplicationController
  include Estimator

  def make_quote
    QuoteCalulator.query(shipping_params)
  end



private

  def shipping_params
  end


end
