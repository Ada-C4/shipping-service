require './lib/Estimator.rb'
class EstimatesController < ApplicationController
  include Estimator

  def quote
    QuoteCalulator.query(shipping_params)
    #takes shipping params
    #does stuff with estimator wrapper
    #renders json
  end




private

  def shipping_params
    params.require(:shipping).permit(:destination[:country, :state, :city, :postal_code], :package[:origin[:country, :state, :city, :postal_code], :package_item[:weight, :dimensions]])
  end


end
