class Package < ActiveRecord::Base
  validates_presence_of :weight, :dimensions
  belongs_to :shipment
end
