require 'rails_helper'
require 'pry'
require 'support/params_hash.rb'

RSpec.describe EstimatesController, type: :controller do
  describe "POST 'quote'" do
    include_context "using shipping params"
    
    it "is successful" do
      post :quote, params, { format: :json }
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      post :quote, params, { format: :json }
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
