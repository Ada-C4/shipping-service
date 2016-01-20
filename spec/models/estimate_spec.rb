require 'rails_helper'

RSpec.describe Estimate, type: :model do
  let(:estimate) { build(:estimate) }

  describe "validations" do
    it "has a price" do
      expect(estimate).to be_valid
      expect(build(:estimate, price: nil)).to be_invalid
    end

    it "has a carrier" do

    end

    it "has a service_name" do

    end
  end
end
