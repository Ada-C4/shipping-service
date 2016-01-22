require 'rails_helper'
require 'support/vcr_setup'

RSpec.describe EstimatesController, type: :controller do
  let!(:value) do
    {
      value: 2000
    }
  end

  let!(:destination) do
    {
      country: "US",
      state: "CA",
      city: "San Francisco",
      zip: "94101"
    }
  end

  describe "GET 'estimate'" do
    before :each do

    end
    it "is successful" do
      get :estimate
      expect(response.response_code).to eq 200
    end

  # describe 'get_usps_estimates' do
  #     it 'returns a hash with service names and cost' do
  #       expect(response.body).to eq ""
  #     end
  # end
  end
end
