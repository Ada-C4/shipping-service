require 'rails_helper'
require 'support/vcr_setup'
require './spec/support/shared_tests'

RSpec.describe ShippingController, type: :controller do
  context "UPS delivery", :vcr do
    it_behaves_like "a shipping carrier" do
      let(:carrier_path) { :ups_rates }
    end
  end

  context "USPS delivery", :vcr do
    it_behaves_like "a shipping carrier" do
      let(:carrier_path) { :usps_rates }
    end
  end
end
