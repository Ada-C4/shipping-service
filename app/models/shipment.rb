class Shipment < ActiveRecord::Base
  has_many :packages
  has_many :estimates
end
