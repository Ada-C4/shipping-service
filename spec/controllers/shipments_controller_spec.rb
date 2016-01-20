require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do
  let(:successful_params) do
    { origin: { country: "USA", city: "Seattle", state: "WA", zip: 98105 },
    destination: { country: "USA", city: "Seattle", state: "WA", zip: 98105 },
    packages: [{ weight: 400, dimensions: [4, 5, 6] },
      { weight: 100, dimensions: [6, 6, 8] }]
    }
  end
  let(:keys) { ["price", "carrier", "service_name", "id"] }

  describe "GET 'shipment'" do
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

      it "is an array of estimate objects" do
        expect(@response).to be_an_instance_of Array
        expect(@response.length).to eq 2
      end

      it "includes only the id, price, carrier, service name" do
        expect(@response.map(&:keys).flatten.uniq.sort).to eq keys
      end
    end
  end
end
