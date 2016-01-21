require 'rails_helper'

RSpec.describe CarriersController, type: :controller do
  describe "GET index" do
    context "shipping rates" do

      # not working
      it "generates UPS rates" do
        VCR.use_cassette 'ups_rates' do
          expect(assigns(:ups_rates)).to be_an(Array)
        end
      end

    end
  end
end
