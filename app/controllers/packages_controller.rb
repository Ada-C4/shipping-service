class PackagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def rates
    begin
      package = create_package(params)
      origin = create_origin(params)
      destination = create_destination(params)

      begin
        # Tries to get both UPS and USPS. Sometimes USPS fails so the sub-rescue method will return just UPS if hit
        usps = ActiveShipping::USPS.new(login: ENV["USPS_USERNAME"], password: ENV["USPS_PASSWORD"])
        usps_response = usps.find_rates(origin, destination, package)
        usps_rates = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

        ups = ActiveShipping::UPS.new(login: ENV["UPS_ACCOUNT_NAME"], password: ENV["UPS_ACCOUNT_PASSWORD"], key: ENV["UPS_ACCESS_KEY"])
        ups_response = ups.find_rates(origin, destination, package)
        ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
        #
        # fedex = ActiveShipping::FedEx.new(:test => true, login: ENV["FEDEX_LOGIN"], password: ENV["FEDEX_PASSWORD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACCOUNT"])
        # response = fedex.find_rates(origin, destination, package)
        # fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

        all_rates = { ups: ups_rates, usps: usps_rates}
        render :json => all_rates.as_json

      rescue
        ups = ActiveShipping::UPS.new(login: ENV["UPS_ACCOUNT_NAME"], password: ENV["UPS_ACCOUNT_PASSWORD"], key: ENV["UPS_ACCESS_KEY"])
        ups_response = ups.find_rates(origin, destination, package)
        ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

        all_rates = { ups: ups_rates }
        render :json => all_rates.as_json
      end

    rescue
      render :json => [], :status => :no_content
    end
  end

  private

  def create_package(params)
    @package = ActiveShipping::Package.new(params[:package][:weight].to_i, [params[:package][:length].to_i, params[:package][:width].to_i, params[:package][:height].to_i], :units => params[:package][:units])
  end

  def create_destination(params)
    @destination = ActiveShipping::Location.new(country: params[:destination_address][:country],
                                            state: params[:destination_address][:state],
                                            city: params[:destination_address][:city],
                                            zip: params[:destination_address][:zip])
  end

  def create_origin(params)
    @origin = ActiveShipping::Location.new(country: params[:origin_address][:country],
                                            state: params[:origin_address][:state],
                                            city: params[:origin_address][:city],
                                            zip: params[:origin_address][:zip])
  end
end
