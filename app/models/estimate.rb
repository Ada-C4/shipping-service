class Estimate < ActiveRecord::Base
  belongs_to :shipment
  validates_presence_of :price, :carrier, :service_name
  
end
