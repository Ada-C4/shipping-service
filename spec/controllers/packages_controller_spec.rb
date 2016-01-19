require 'rails_helper'

RSpec.describe PackagesController, type: :controller do

  describe "GET 'rates'" do
    it "is successful" do
      get :rates
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :rates
      expect(response.header['Content-Type']).to include 'application/json'
    end

    context "the returned json object" do
      before :each do
        get :rates
        @response = JSON.parse response.body
      end

      it "has the right keys" do
        expect(@response.keys.sort).to eq keys
      end

      it "has all of Rosa's info" do
        keys.each do |key|
          expect(@response[key]).to eq rosa[key]
        end
      end
    end

    context "no rates found" do
      before :each do
        get :rates
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
