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
              :package_items =>
              [{ :weight => 12,
                :height => 15,
                :length => 10,
                :width => 12 },
               { :weight => 3,
                 :height => 11,
                 :length => 1,
                 :width => 14 },
               { :weight => 30,
                 :height => 3,
                 :length => 40,
                 :width => 5 }]},
            { :origin =>
              { :country => "US",
                :state => "CT",
                :city => "New London",
                :postal_code => "06320"},
              :package_items =>
                [{:weight => 9,
                :height => 2,
                :length => 17,
                :width => 14 }]}]
          }
        }
    end


    it "is successful" do
      post :get_quote, params, { format: :json }
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      post :get_quote, params, { format: :json }
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
