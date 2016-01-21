require 'rails_helper'

RSpec.describe EstimatesController, type: :controller do
  describe "GET 'quote'" do

    let(:shipping_params) {
      { destination:
        { country: "US", state: "WA", city: "Seattle", postal_code: "98122"},
      { package:
        {:origin
          { country: "US", state: "MA", city: "Hinsdale", postal_code: "01235"}
          { weight: 12, dimensions: [15, 10, 4.5] }
        }
      }}}


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
