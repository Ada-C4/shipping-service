require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  let(:params) do {
      destination: {
        country: "US",
        state: "WA",
        city: "Seattle",
        zip: "98112"
      },
      origin: {
        country: "US",
        state: "FL",
        city: "Ft Lauderdale",
        zip: "33316"
      },
      package: {
        weight: 100,
        length: 10,
        width: 10,
        height: 10,
        units: "metric"
      }
    }
  end

  let(:bad_package_params) do {
    destination: {
      country: "US",
      state: "WA",
      city: "Seattle",
      zip: "98112"
    },
    origin: {
      country: "US",
      state: "FL",
      city: "Ft Lauderdale",
      zip: "33316"
    },
    package: {
      weight: "",
      length: 10,
      width: 10,
      height: 10,
      units: "metric"
    }
  }
end

  let(:bad_origin_params) do {
    destination: {
      country: "US",
      state: "WA",
      city: "Seattle",
      zip: "98112"
    },
    origin: {
      country: "",
      state: "FL",
      city: "Ft Lauderdale",
      zip: "33316"
    },
    package: {
      weight: 100,
      length: 10,
      width: 10,
      height: 10,
      units: "metric"
    }
  }
end

  let(:bad_destination_params) do {
    destination: {
      country: "",
      state: "WA",
      city: "Seattle",
      zip: "98112"
    },
    origin: {
      country: "US",
      state: "FL",
      city: "Ft Lauderdale",
      zip: "33316"
    },
    package: {
      weight: 100,
      length: 10,
      width: 10,
      height: 10,
      units: "metric"
    }
  }
  end

  let(:false_params) do {
    destination: {
      country: "US",
      state: "FL",
      city: "Ft Lauderdale",
      zip: "33316"
    },
    origin: {
      country: "US",
      state: "FL",
      city: "Ft Lauderdale",
      zip: "33316"
    },
    package: {
      weight: 100,
      length: 10,
      width: 10,
      height: 10,
      units: "metric"
    }
  }
end

  let(:keys) { ["ups", "usps"]}

   describe "GET 'rates'" do
    it "is successful" do
      get :rates, params
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :rates, params
      expect(response.header['Content-Type']).to include 'application/json'
    end

    context "the returned json object" do
      before :each do
        get :rates, params
        @response = JSON.parse response.body
      end

      it "has the right keys" do
        expect(@response.keys.sort).to eq keys
      end
    end

    context "bad params passed" do
      it "returns an error if incorrect package params are passed" do
        get :rates, bad_package_params
        @response = JSON.parse response.body
        expect(@response).to eq ["Incorrect or missing parameters for package"]
      end

      it "returns an error if incorrect origin params are passed" do
        get :rates, bad_origin_params
        @response = JSON.parse response.body
        expect(@response).to eq ["Incorrect or missing parameters for origin address"]
      end

      it "returns an error if incorrect package params are passed" do
        get :rates, bad_destination_params
        @response = JSON.parse response.body
        expect(@response).to eq ["Incorrect or missing parameters for destination address"]
      end

    end

    context "no rates found" do

      #
      # it "is successful if no rates are found" do
      #   expect(response).to be_successful
      # end
      #
      # it "returns a 204 (no content)" do
      #   expect(response.response_code).to eq 204
      # end
      #
      # it "expects the response body to be an empty array" do
      #   expect(response.body).to eq "[]"
      # end
    end

  end
end
