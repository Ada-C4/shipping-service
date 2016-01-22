require 'rails_helper'
require 'ups'
require 'usps'

RSpec.describe ShipmentsController, type: :controller do
  describe "get #rates" do
    before :each do 
      shipment = {shipment: { origin: { country: "USA", state: "WA", city: "Seattle", zip: "98121" }, destination: { street: "Ada Street", state: "WA", city: "Seattle", zip: "98112" }, packages: { weight: 10, height: 5, length: 5, width: 5 } } } 

      @json = shipment.to_json
    end

    it "gets the page succesfully" do 
      get :rates, json_data: @json
      expect(response).to be_successful
      expect(response.response_code).to eq 200
    end

    it "returns JSON" do 
      get :rates, json_data: @json
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "returns estimates as array when full" do 
      get :rates, json_data: @json

      expect(JSON.parse(response.body)).to be_an Array
    end

    it "returns them in the right order" do 
      get :rates, json_data: @json
      expect(JSON.parse(response.body).first[1]).to be <= JSON.parse(response.body).last[1].to_i
    end

    it "returns json even if empty" do 
      VCR.use_cassette("shipment_controller_api_empty", :record => :new_episodes) do 
        get :rates, json_data: @json
        expect(response.response_code).to eq 204
      end
    end

  end
end
