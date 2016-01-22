class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def set_packages
    packages = []
    params[:packages].each do |package|
      packages << ActiveShipping::Package.new(package[:weight].to_i, package[:dimensions].map(&:to_i))
    end

    return packages
  end

  def set_origin
    ActiveShipping::Location.new(country: 'US', state: params[:origin][:state], city: params[:origin][:city], zip: params[:origin][:zip])
  end

  def set_destination
    ActiveShipping::Location.new(country: 'US', state: params[:destination][:state], city: params[:destination][:city], zip: params[:destination][:zip])
  end
end
