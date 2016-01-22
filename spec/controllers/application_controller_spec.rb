require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "post 'ups_get_rates'" do
    it "is successful" do
      post :ups_get_rates
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      post :ups_get_rates
      expect(response.header['Content-Type']).to include 'application/json'
    end

    context "the returned json object" do
      before :each do
        merchant
        order
        post :ups_get_rates
        @response = JSON.parse response.body
      end

      it "is an array of rate objects" do
        expect(@response).to be_an_instance_of Array
        expect(@response.length).to eq 2
      end

      it "includes the keys" do
        expect(@response.map(&:keys).flatten.uniq.sort).to eq keys
      end
    end
  end
end
