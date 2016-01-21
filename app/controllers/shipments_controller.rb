class ShipmentsController < ApplicationController
respond_to :json

  def estimate
    package = ActiveShipping::Package.new(params[:package][:weight], params[:package][:dimensions])
    packages = [package]
    origin = ActiveShipping::Location.new(params[:origin])
    destination = ActiveShipping::Location.new(params[:destination])

    ups = ups_rates(origin, destination, packages)
    render :json => ups.as_json, :status => :ok
    # usps = usps_rates(origin, destination, packages)
    #combine ups and usps into one json object
    #return that object to seabay
  end

private

  def package_params
    params.require(:package).permit(:weight, :dimensions => [])
  end

  def origin_params
    params.require(:origin).permit(:country, :state, :province, :city, :zip, :postal_code)
  end

  def destination_params
    params.require(:destination).permit(:country, :state, :province, :city, :zip, :postal_code)
  end


  def ups_rates(origin, destination, packages)
    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    response = ups.find_rates(origin, destination, packages)

    ups_rate_response = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

end
