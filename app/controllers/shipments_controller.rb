class ShipmentsController < ApplicationController
respond_to :json

  def estimate
    begin
      weight = (package_params[:weight]).to_i
      dimensions = [(package_params[:length]).to_i,  (package_params[:width]).to_i,  (package_params[:height]).to_i]
      package = ActiveShipping::Package.new(weight, dimensions)
      packages = [package]
      origin = ActiveShipping::Location.new(origin_params)
      destination = ActiveShipping::Location.new(destination_params)
      
      ups = ups_rates(origin, destination, packages)
      usps = usps_rates(origin, destination, packages)
      rates = ups.merge(usps)
      render :json => rates.as_json, :status => :ok
    rescue
      render :json => { error: :bad_data, message: "You must provide valid data for package size, package weight, origin location and destination location." }, status: :bad_request
    end
  end

private

  def package_params
    params.require(:package).permit(:weight, :length, :width, :height)
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

    ups_rate_response = {}
    response.rates.sort_by(&:price).each do |rate|
      ups_rate_response[rate.service_name] = rate.price
    end
    return ups_rate_response
  end

  def usps_rates(origin, destination, packages)
    usps = ActiveShipping::USPS.new(login: ENV['USPS_USERNAME'])
    response = usps.find_rates(origin, destination, packages)

    usps_rate_response = {}
    response.rates.sort_by(&:price).each do |rate|
      usps_rate_response[rate.service_name] = rate.price
    end
    return usps_rate_response
  end

end
