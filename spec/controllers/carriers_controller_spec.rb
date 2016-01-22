require 'rails_helper'

RSpec.describe CarriersController, type: :controller do
  describe "GET index" do
    context "shipping rates" do
      let(:query) do
        {"origin"=>{:country=>"US", :state=>"CA", :city=>"Beverly Hills", :zip=>"90210"},"destination"=>{:country=>"US", :state=>"WA", :city=>"Seattle", :zip=>"98103"},"packages"=>[{:weight=>100, :height=>50, :length=>20, :width=>30}]}
      end

      it "generates UPS rates", :vcr do
        get :index, query
        # expect(assigns(:ups_response)).to be_an(Array)
      end
    end
  end
end
