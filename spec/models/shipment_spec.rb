require 'rails_helper'

RSpec.describe Shipment, type: :model do

  describe "initialize" do
    it "sets @origin" do

    end
    it "sets @destination"
    it "creates an Estimate object for each shipping method" do

    end
    it "sets @packages" do
      # expect(shipment.packages).to be_a(Array)
    end
    it "creates at least one new Package object" do

    end
    it "creates a Package for each orderitem in the Order" do

    end
  end

  describe "get_quotes" do

  end

end
