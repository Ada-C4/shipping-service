require 'rails_helper'

RSpec.describe PackagesController, type: :controller do

  describe "GET 'rates'" do
    it "is successful" do
      get :rates, :state => "GA", :city => "Atlanta", :zip => 30307
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :rates, :state => "GA", :city => "Atlanta", :zip => 30307
      expect(response.header['Content-Type']).to include 'application/json'
    end

    context "the returned json object" do
      before :each do
        get :rates, :state => "GA", :city => "Atlanta", :zip => 30307
        @response = JSON.parse response.body
      end

      it "is an array of shipping objects" do
        expect(@response).to be_an_instance_of Hash
        expect(@response.length).to eq 2
      end

      it "includes the appropriate keys" do
        expect(@response.keys).to eq ["ups", "usps"]
      end
    end

    context "ups response" do
      it "returns an array of prices" do
        get :rates, :state => "GA", :city => "Atlanta", :zip => 30307
        response_json = JSON.parse response.body
        expect(response_json["ups"]).to be_an_instance_of Array
      end
    end

    context "usps resoponse" do
      it "returns an array of prices" do
        get :rates, :state => "GA", :city => "Atlanta", :zip => 30307
        response_json = JSON.parse response.body
        expect(response_json["usps"]).to be_an_instance_of Array
      end
    end

  end
end
