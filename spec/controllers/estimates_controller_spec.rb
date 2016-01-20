require 'rails_helper'

RSpec.describe EstimatesController, type: :controller do
  describe "GET 'quote'" do
    it "is successful" do
      get :quote
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :quote
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
