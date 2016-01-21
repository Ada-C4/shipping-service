require 'rails_helper'

RSpec.describe Carrier, type: :model do
  describe ".activate_ups" do
    it "sets up UPS credentials" do
      VCR.use_cassette 'model/ups_response' do
        response = Carrier.activate_ups
        expect(response).to be_an_instance_of ActiveShipping::UPS
      end
    end
  end
  describe ".activate_usps" do
    it "sets up USPS credentials" do
      VCR.use_cassette 'model/usps_response' do
        response = Carrier.activate_usps
        expect(response).to be_an_instance_of ActiveShipping::USPS
      end
    end
  end
end
