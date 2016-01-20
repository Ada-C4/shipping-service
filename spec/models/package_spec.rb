require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:package) { build(:package) }

  describe "validations" do
    it "has a weight" do
      expect(package).to be_valid
      expect(build(:package, weight: nil)).to be_invalid
    end

    it "has dimensions" do
      expect(package).to be_valid
      expect(build(:package, dimensions: nil)).to be_invalid
    end
  end
end
