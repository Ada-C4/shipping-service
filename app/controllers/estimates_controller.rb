require './lib/Estimator.rb'
class EstimatesController < ApplicationController
  include Estimator

  def quote
    QuoteCalulator.query(shipping_params)
  end




private

  def shipping_params
    params.require(:shipping).permit(:destination[:country, :state, :city, :postal_code], :package[:origin[:country, :state, :city, :postal_code], :package_item[:weight, :length, :width, :height]])
  end


end
