require 'rails_helper'
require 'pry'
require 'support/params_hash.rb'

RSpec.describe EstimatesController, type: :controller do
  describe "POST 'quote'" do
    include_context "using shipping params"

    context "successful api call" do
      it "is successful" do
        post :quote, params, { format: :json }
        expect(response.response_code).to eq 200
      end

      it "returns json" do
        post :quote, params, { format: :json }
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end

    context "failed api call" do
      it "returns a 204 (no content)" do
        post :quote, bad_params, { format: :json }
        expect(response.response_code).to eq 204
      end
    end
  end
end
