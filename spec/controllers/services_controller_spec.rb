require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  let!(:ups) { ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY']) }
  let!(:usps) { ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN']) }
  let(:keys)   { ["date", "price", "rate"] }
  let(:params) do
    { packages: [{ dimensions: [25, 10, 15], weight: 500 }, { dimensions: [18, 30, 10], weight: 5000 }], origin: { state: "WA", city: "Seattle", zip: "98101" }, destination: { state: "IL", city: "Vernon Hills", zip: "60061" } }
  end
  let(:bad_params) do
    { packages: [{ dimensions: [25, 10, 15], weight: 500 }], origin: { state: "WA", city: "Seattle", zip: "98101" }, destination: { state: "MadeUpState", city: "Vernon Hills", zip: "98101" } }
  end

  describe "POST 'ship'" do
    it "is successful" do
      post :ship, params.merge({service: 'ups'})
      expect(response.response_code).to eq 200
    end

    it "is successful" do
      post :ship, params.merge({service: 'usps'})
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      post :ship, params.merge({service: 'ups'})
      expect(response.header['Content-Type']).to include 'application/json'
    end

    context "the returned json object" do
      before :each do
        post :ship, params.merge({service: 'ups'})
        @response = JSON.parse response.body
      end

      it "is an array of pet objects" do
        expect(@response).to be_an_instance_of Hash
        expect(@response["data"].length).to be > 0
      end

      it "includes only the id, name, human, and age keys" do
        expect(@response["data"].map(&:keys).flatten.uniq.sort).to eq keys
      end
    end

    context "bad api request" do
      before :each do
        post :ship, bad_params.merge({service: 'ups'})
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
