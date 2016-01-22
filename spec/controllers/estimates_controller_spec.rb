require 'rails_helper'
require 'support/vcr_setup'

RSpec.describe EstimatesController, type: :controller do
  let!(:package) do
    {
      value: 2000
    }
  end

  let!(:destination) do
    {
      destination: {
        state: "CA",
        city: "San Francisco",
        zip: 94104
      }
    }
  end

  describe "GET 'estimate'" do

    it "is successful", :vcr do
      get :estimate, destination.merge(package)
      expect(response.response_code).to eq 200
    end

  # describe 'get_usps_estimates' do
  #     it 'returns a hash with service names and cost' do
  #       expect(response.body).to eq ""
  #     end
  # end
  end
end
