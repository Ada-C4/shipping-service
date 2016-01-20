require 'rails_helper'

RSpec.describe Estimate, type: :model do
  let(:estimate) { build(:estimate) }

  describe "validations" do
    it "has a price" do
      expect(estimate).to be_valid
      expect(build(:estimate, price: nil)).to be_invalid
    end

    it "has a carrier" do
      expect(estimate).to be_valid
      expect(build(:estimate, carrier: nil)).to be_invalid
    end

    it "has a service_name" do
      expect(estimate).to be_valid
      expect(build(:estimate, service_name: nil)).to be_invalid
    end
  end
end
