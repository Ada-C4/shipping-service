require 'rails_helper'

RSpec.describe Shipment, type: :model do

  let(:shipment) { build(:shipment) }
  let(:origin) { ActiveShipping::Location.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210') }
  let(:destination) { ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: 98105) }
  let (:packages) { [ActiveShipping::Package.new(50, [3,4,5]), ActiveShipping::Package.new(5, [3,4,5])] }

  describe "get_quotes", :vcr do
    it "returns an array" do
      expect(shipment.get_quotes(origin, destination, packages)).to be_an_instance_of Array
    end

    # it "returns an array of 2 items" do
    #
    # end
    #
    # it "returns an array of 2 items, with service name as 1st item within 1st item" do
    #
    # end
    #
    # it "returns an array of 2 items, with integer as 12nd item within 1st item" do
    #
    # end
  end

end
