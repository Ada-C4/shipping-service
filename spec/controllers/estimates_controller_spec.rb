require 'rails_helper'
require 'pry'
require 'support/params_hash.rb'

RSpec.describe EstimatesController, type: :controller do
  describe "POST 'quote'" do
    include_context "using shipping params"

    context "successful api call" do
      it "is successful" do
        get :quote, params, { format: :json }
        expect(response.response_code).to eq 200
      end

      it "returns json" do
        get :quote, params, { format: :json }
        expect(response.header['Content-Type']).to include 'application/json'
      end

      it "returned json that is formatted properly" do
        get :quote, params, { format: :json }
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["UPS"]).to_not be_nil
        expect(parsed_body["UPS"]["UPS Ground"]).to_not be_nil
        expect(parsed_body["USPS"]).to_not be_nil
      end
    end

    context "failed api call" do
      it "returns a 204 (no content)" do
        get :quote, bad_params, { format: :json }
        expect(response.response_code).to eq 204
      end
    end
  end
end
