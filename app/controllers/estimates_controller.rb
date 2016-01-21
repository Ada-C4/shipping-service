class EstimatesController < ApplicationController
  include Estimator
  require 'active_shipping'
  require 'pry'

  def get_quote
    ship_params = strong_shipping_params
    quote = Estimate.query(ship_params)
    #takes shipping params
    #does stuff with estimator wrapper
    #renders json
    if quote
      render :json => quote.as_json(except: [:created_at, :updated_at]),
      :status => :ok
    else
      render :json => [], :status => :no_content
    end
  end




private

  def strong_shipping_params
    binding.pry
    params.require(:shipping_params).permit(:destination => [:country, :state, :city, :postal_code], :packages => {:origin => [:country, :state, :city, :postal_code], :package_items => [:weight, :height, :length, :width]})
  end


end
