class PackagesController < ApplicationController

  def rates
    if params["package"]["width"].to_i == 0 || params["package"]["height"].to_i == 0 || params["package"]["length"].to_i == 0 || params["package"]["weight"].to_i == 0
      return render :json => ["Incorrect or missing parameters for package"], :status => :bad_request
    end

    package = ActiveShipping::Package.new(params[:package][:weight].to_i, [params[:package][:length].to_i, params[:package][:width].to_i, params[:package][:height].to_i], :units => params[:package][:units])


    begin
      origin = ActiveShipping::Location.new(params[:origin])
    rescue
      return render :json => ["Incorrect or missing parameters for origin address"], :status => :bad_request
    end

    begin
      destination = ActiveShipping::Location.new(params[:destination])
    rescue
      return render :json => ["Incorrect or missing parameters for destination address"], :status => :bad_request
    end

    begin
      usps = ActiveShipping::USPS.new(login: ENV["USPS_USERNAME"], password: ENV["USPS_PASSWORD"])
      usps_response = usps.find_rates(origin, destination, package)
      usps_rates = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

      ups = ActiveShipping::UPS.new(login: ENV["UPS_ACCOUNT_NAME"], password: ENV["UPS_ACCOUNT_PASSWORD"], key: ENV["UPS_ACCESS_KEY"])
      ups_response = ups.find_rates(origin, destination, package)
      ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

      all_rates = { ups: ups_rates, usps: usps_rates}
      render :json => all_rates.as_json
    rescue
      return render :json => "There has been an error", :status => :no_content
    end
  end
end
