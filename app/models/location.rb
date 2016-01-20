class Location < ActiveRecord::Base
  validates_presence_of :country, :city, :state, :zip

  def self.find_or_create_by(hash)
    # return a Location if it exists, or make a new one
  end

end
