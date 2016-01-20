require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location) {build(:location)}

  describe "validations" do
    it "has a country" do
      expect(location).to be_valid
      expect(build(:location, country: nil)).to be_invalid
    end
    it "has a city" do

    end
    it "has a state" do

    end
    it "has a zip" do

    end
  end
end
