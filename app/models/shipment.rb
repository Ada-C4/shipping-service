class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates
  attr_reader :origin, :destination, :packages

  def initialize(hash)
    @origin = Location.new(params[:origin])
    @destination = Location.new(params[:destination])
    @packages = []
    params[:packages].each { |package| @packages << Package.new(package) }
  end
end
