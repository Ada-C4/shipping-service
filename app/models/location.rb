class Location < ActiveRecord::Base
  validates_presence_of :country, :city, :state, :zip

  def self.find_or_create_by(params)
    # return a Location if it exists, or make a new one
    location = Location.find_by(country: params[:origin][:country], city: params[:origin][:city], state: params[:origin][:state], zip: params[:origin][:zip])

    if location.nil?
      location = Location.new
      location.country = params[:origin][:country]
      location.city = params[:origin][:city]
      location.state = params[:origin][:state]
      location.zip = params[:origin][:zip]
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
