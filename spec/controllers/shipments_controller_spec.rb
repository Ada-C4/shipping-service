require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do
  describe "GET 'estimate'" do
    let(:params) do
      {origin: {country: 'US',
                 state: 'CA',
                 city: 'Beverly Hills',
                 zip: '90210'},

      destination: {country: 'CA',
              province: 'ON',
              city: 'Ottawa',
              postal_code: 'K1P 1J1'}
    end

    it "is successful" do
      get :estimate
      expect(response.response_code).to eq 200
    end
  end

  end
