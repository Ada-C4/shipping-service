require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do
  describe "GET 'estimate'" do
    it "is successful" do
      get :estimate
      expect(response.response_code).to eq 200
    end
  end

  end
