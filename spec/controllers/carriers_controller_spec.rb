require 'rails_helper'

RSpec.describe CarriersController, type: :controller do
  describe "GET index" do
    let(:query) do
      {
        origin: {
          :country=>"US",
          :state=>"CA",
          :city=>"Beverly Hills",
          :zip=>"90210"
        },
        destination: {
          :country=>"US",
          :state=>"WA",
          :city=>"Seattle",
          :zip=>"98103"},
        packages: [
          {
            :weight=>100,
            :height=>50,
            :length=>20,
            :width=>30
          }
        ]
      }
    end

    context "shipping rates" do
      it "generates UPS rates", :vcr do
        get :index, query
        expect(assigns(:ups_rates)).to be_an(Array)
      end

      it "generates USPS rates", :vcr do
        get :index, query
        expect(assigns(:usps_rates)).to be_an(Array)
      end
    end

    context "missing shipping rates" do
      it "both rates are missing" do
        allow(Carrier).to receive(:get_rates).and_return([nil, nil])
        get :index, query
        expect(response.response_code).to eq 204
      end
      it "only USPS is missing" do
        allow(Carrier).to receive(:get_rates).and_return([Array.new, nil])
        get :index, query
        expect(response.response_code).to eq 200
      end
      it "only UPS is missing" do
        allow(Carrier).to receive(:get_rates).and_return([nil, Array.new])
        get :index, query
        expect(response.response_code).to eq 200
      end
    end
  end
end
