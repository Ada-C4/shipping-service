require 'rails_helper'
require 'pry'

RSpec.describe EstimatesController, type: :controller do
  describe "GET 'quote'" do

    let(:params) do
      { :shipping_params =>
         {:destination =>
          { :country => "US",
            :state => "WA",
            :city => "Seattle",
            :postal_code => "98122"},
          :packages =>
            [{ :origin =>
              { :country => "US",
                :state => "MA",
                :city => "Hinsdale",
                :postal_code => "01235"},
              :package_item =>
              {:weight => 12,
              :dimensions => [15, 10, 4.5] }},
            { :origin =>
              { :country => "US",
                :state => "CT",
                :city => "New London",
                :postal_code => "06320"},
              :package_item =>
                {:weight => 9,
                :dimensions => [2, 10, 4.5] }}]
          }
        }
    end


    it "is successful" do
      post :quote, params, { format: :json }
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      post :quote, shipping_params, { format: :json }
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
