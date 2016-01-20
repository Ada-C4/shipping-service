class Location < ActiveRecord::Base
  validates_presence_of :country, :city, :state, :zip

  def self.find_or_create_by(hash)
    # return a Location if it exists, or make a new one
    location = Location.find_by(country: hash[:country], city: hash[:city], state: hash[:state], zip: hash[:zip])

    if location.nil?
      location = Location.new
      location.country = hash[:country]
      location.city = hash[:city]
      location.state = hash[:state]
      location.zip = hash[:zip]
      if location.save
        return location
      else
        # TODO what should happen if location doesn't save?
      end
    else
      return location
    end
  end

end
