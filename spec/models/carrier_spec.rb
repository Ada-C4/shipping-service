require 'rails_helper'

RSpec.describe Carrier, type: :model do
  describe ".get_rates" do
    context "timeout" do
      let(:query) do
        {
          origin: {
            :country=>"US",
            :state=>"CA",
            :city=>"Beverly Hills",
            :zip=>"90210"
          },
          destination: {
            :country=>"US",
            :state=>"WA",
            :city=>"Seattle",
            :zip=>"98103"},
          packages: [
            {
              :weight=>100,
              :height=>50,
              :length=>20,
              :width=>30
            }
          ]
        }
      end

      it "UPS times out", :vcr do
        allow(Carrier).to receive(:activate_ups).and_raise(Timeout::Error)
        carrier = Carrier.get_rates(query)
        expect(carrier[0]).to be_nil
        expect(carrier[1]).not_to be_nil
      end
      it "USPS times out", :vcr do
        allow(Carrier).to receive(:activate_usps).and_raise(Timeout::Error)
        carrier = Carrier.get_rates(query)
        expect(carrier[1]).to be_nil
        expect(carrier[0]).not_to be_nil
      end
    end
  end

  describe ".activate_ups" do
    it "sets up UPS credentials" do
      response = Carrier.activate_ups
      expect(response).to be_an_instance_of ActiveShipping::UPS
    end
  end

  describe ".activate_usps" do
    it "sets up USPS credentials" do
      response = Carrier.activate_usps
      expect(response).to be_an_instance_of ActiveShipping::USPS
    end
  end

  describe ".create_origin" do
    let(:origin_params) do
      {
        country:  'US',
        state:    'WA',
        city:     'Seattle',
        zip:      '98103'
      }
    end

    it "creates a new Location object" do
      expect(Carrier.create_origin(origin_params)).to be_an_instance_of ActiveShipping::Location
    end
  end

  describe ".create_destination" do
    let(:destination_params) do
      {
        country:  'US',
        state:    'WA',
        city:     'Seattle',
        zip:      '98103'
      }
    end

    it "creates a new Location object" do
      expect(Carrier.create_destination(destination_params)).to be_an_instance_of ActiveShipping::Location
    end
  end

  describe ".create_packages" do
    let(:package_params) do
      [
        {
          weight: 100,
          height: 50,
          length: 20,
          width:  30
        },
        {
          weight: 200,
          height: 30,
          length: 10,
          width:  22
        },
      ]
    end

    it "returns an array" do
      expect(Carrier.create_packages(package_params)).to be_an Array
    end

    it "creates Package objects" do
      expect(Carrier.create_packages(package_params)[0]).to be_an_instance_of ActiveShipping::Package
    end

  end

end
