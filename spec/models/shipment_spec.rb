require 'rails_helper'

RSpec.describe Shipment, type: :model do

  describe "get_origin" do
    it "creates a new Location object" do
      
    end
  end
  describe "get_destination" do
    it "creates a new Location object" do
      
    end
  end
  describe "get_packages" do
    it "creates at least one new Package object" do
      
    end
    # Not sure if this is the best way to phrase this test
    it "creates a Package for each orderitem in the Order" do
      
    end
  end
  describe "get_estimate" do
    it "creates an Estimate object for each shipping method" do
      
    end
  end

end
