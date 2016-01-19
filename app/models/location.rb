class Location < ActiveRecord::Base
  validates_presence_of :country, :city, :state, :zip
end
