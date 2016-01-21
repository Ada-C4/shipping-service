require 'rails_helper'

RSpec.describe EstimatesController, type: :controller do
  describe "GET 'quote'" do

    let(:shipping_params) do
      { destination =>
        { :country => "US",
          :state => "WA",
          :city => "Seattle",
          :postal_code => "98122"},
        packages =>
        {1 =>
          { :origin =>
            { :country => "US",
              :state => "MA",
              :city => "Hinsdale",
              :postal_code => "01235"},
            :weight => 12,
            :dimensions => [15, 10, 4.5] },
         2 =>
          { :origin =>
            { :country => "US",
              :state => "CT",
              :city => "New London",
              :postal_code => "06320"},
            :weight => 1,
            :dimensions => [9, 10, 4.5] }
        }
      }
    end


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
