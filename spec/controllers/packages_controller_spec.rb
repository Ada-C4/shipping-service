require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  let(:params) do {
      destination_address: {
        country: "US",
        state: "WA",
        city: "Seattle",
        zip: "98112"
      },
      origin_address: {
        country: "US",
        state: "FL",
        city: "Ft Lauderdale",
        zip: "33316"
      },
      package: {
        weight: 100,
        length: 10,
        width: 20,
        height: 30,
        units: "metric"
      }
    }
  end

  let(:bad_params) do {
      destination_address: {
        country: "US",
        state: "WA",
        city: "Seattle",
        zip: ""
      }
    }
  end

  let(:keys) { ["ups", "usps"]}

  describe "GET 'rates'" do
    it "is successful" do
      get :rates, params
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :rates, params
      expect(response.header['Content-Type']).to include 'application/json'
    end

    context "the returned json object" do
      before :each do
        get :rates, params
        @response = JSON.parse response.body
      end

      it "has the right keys" do
        expect(@response.keys.sort).to eq keys
      end
    end

    context "no rates found" do
      before :each do
        get :rates, bad_params
      end

      it "is successful" do
        expect(response).to be_successful
      end

      it "returns a 204 (no content)" do
        expect(response.response_code).to eq 204
      end

      it "expects the response body to be an empty array" do
        expect(response.body).to eq "[]"
      end
    end

  end
end
