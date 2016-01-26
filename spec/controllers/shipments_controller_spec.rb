require 'rails_helper'
require 'pry'

RSpec.describe ShipmentsController, type: :controller do
  describe "POST 'estimate'" do
    let(:params) do
      {origin: {country: 'US',
                 state: 'CA',
                 city: 'Beverly Hills',
                 zip: '90210'},

      destination: {country: 'CA',
                    province: 'ON',
                    city: 'Ottawa',
                    postal_code: 'K1P 1J1'},
      package: { weight: 100,
                length: 93,
                width: 10,
                height: 10}
              }
    end

    it "is successful" do
      post :estimate, params
      expect(response.response_code).to eq 200
    end
  end

  end
