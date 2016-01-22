require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:package){ ActiveShipping::Package.new(
    100,
    [100,100],
    value: 10000
    )
  }

  describe "#get_package" do
    it "creates a package object" do
      expect(package).to be_an_instance_of Package
    end
  end


end
