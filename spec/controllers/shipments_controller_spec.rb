require 'rails_helper'
require 'pry'

RSpec.describe ShipmentsController, type: :controller do
  let(:successful_params) do
    { origin: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    destination: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    packages: [{ weight: 400, dimensions: [4, 5, 6] },
      { weight: 100, dimensions: [6, 6, 8] }]
    }
  end
  let (:no_origin_params) do
    { destination: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    packages: [{ weight: 400, dimensions: [4, 5, 6] },
      { weight: 100, dimensions: [6, 6, 8] }] }
  end
  let(:no_destination_params) do
    { origin: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    packages: [{ weight: 400, dimensions: [4, 5, 6] },
      { weight: 100, dimensions: [6, 6, 8] }]
    }
  end
  let(:no_packages_params) do
    { origin: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    destination: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    }
  end
  let(:empty_packages_params) do
    { origin: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    destination: { country: "US", city: "Seattle", state: "WA", zip: 98105 },
    packages: []
    }
  end

  describe "GET 'shipment'", :vcr do

    it "is successful" do
      get :shipment, successful_params
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :shipment, successful_params
      expect(response.header['Content-Type']).to include 'application/json'
    end

    context "the returned json object" do
      before :each do
        get :shipment, successful_params
        @response = JSON.parse response.body
      end

      it "is an array of shipping price estimates" do
        expect(@response).to be_an_instance_of Array
        expect(@response.length).to eq 2
      end

      it "includes only the id, price, carrier, service name" do
        expect(@response[0][0][0]).to eq "UPS Ground"
      end
    end

    context "the quote to be returned" do
      before :each do
        get :shipment, successful_params
      end

      let(:origin) { ActiveShipping::Location.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210') }
      let(:destination) { ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: 98105) }
      let (:packages) { [ActiveShipping::Package.new(50, [3,4,5]), ActiveShipping::Package.new(5, [3,4,5])] }

      it "is an array" do
        expect(assigns(:quotes)) .to be_an_instance_of Array
      end

      it "is an array of 2 items" do
        expect(assigns(:quotes).length).to eq 2
      end

      it "each internal array has service name as 1st item within 1st item" do
        expect(assigns(:quotes)[0][0][0]).to eq "UPS Ground"
      end

      it "each internal array has integer as 2nd item within 1st item" do
        expect(assigns(:quotes)[0][0][1]).to eq 1198
      end
    end
  end

  context "with bad requests" do
    it "must have an origin" do
      get :shipment, no_origin_params
      expect(response.status).to eq(400)
      expect(response.body).to include("You didn't submit the correct information.")
    end
    it "must have a destination" do
      get :shipment, no_destination_params
      expect(response.status).to eq(400)
      expect(response.body).to include("You didn't submit the correct information.")
    end
    it "must have packages" do
      get :shipment, no_packages_params
      expect(response.status).to eq(400)
      expect(response.body).to include("You didn't submit the correct information.")
    end
  end

end
