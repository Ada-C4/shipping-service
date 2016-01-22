require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  let(:origin)   { ActiveShipping::Location.new(
                    country: 'US',
                    state: 'WA',
                    city: 'Seattle',
                    zip: 98122)
                  }

  let(:package) { ActiveShipping::Package.new(100,
                              [100,100],
                              valule: 10000)
                }

  let(:destination)   { ActiveShipping::Location.new(
                        country: 'US',
                        state: 'GA',
                        city: 'Atlanta',
                        zip: 30307)
                      }

  let(:ups) { ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
            }

  let(:usps) { ActiveShipping::USPS.new(login: ENV["USPS_LOGIN"])
              }

  describe "GET 'index'" do
    it "is successful" do
      get :index, origin, package, destination, ups, usps
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :index, origin, package, destination, ups, usps
      expect(response.header['Content-Type']).to include 'application/json'
    end

  #   context "the returned json object" do
  #     before :each do
  #       rosa
  #       raquel
  #       get :index
  #       @response = JSON.parse response.body
  #     end
  #
  #     it "is an array of pet objects" do
  #       expect(@response).to be_an_instance_of Array
  #       expect(@response.length).to eq 2
  #     end
  #
  #     it "includes only the id, name, human, and age keys" do
  # # a way to specify that you want to map on a certian field. Put a binding.pry to find out more.
  #       expect(@response.map(&:keys).flatten.uniq.sort).to eq keys
  #     end
  #   end
  end

    describe "#get_package" do
      it "creates a package object" do

        expect(response.status).to eq 200
        expect(package).to be_an_instance_of Hash
      end
    end

    describe "#get_origin" do
      it "creates a location object" do
        expect(origin).to be_an Object
      end
    end

    describe "#get_destination" do
      it "creates a location object" do
        expect(destination).to be_an Object
      end
    end


  # describe "GET 'show'" do
  #   it "is successful" do
  #     get :show, id: rosa.id
  #     expect(response.response_code).to eq 200
  #   end
  #
  #   it "returns json" do
  #     get :show, id: rosa.id
  #     expect(response.header['Content-Type']).to include 'application/json'
  #   end
  #
  #   context "the returned json object" do
  #     before :each do
  #       get :show, id: rosa.id
  #       @response = JSON.parse(response.body)
  #     end
  #
  #     it "has the right keys" do
  #       expect(@response.keys.sort).to eq keys
  #     end
  #
  #     it "has all of Rosa's info" do
  #       keys.each do |key|
  #         expect(@response[key]).to eq rosa[key]
  #       end
  #     end
  #   end
  #
  #
  #   context "no pets found" do
  #     before :each do
  #       get :show, id: 1000
  #     end
  #
  #     it "is successful" do
  #       expect(response).to be_successful
  #     end
  #
  #     it "returns a 204 (no content)" do
  #       expect(response.response_code).to eq 204
  #     end
  #
  #     it "expects the response body to be an empty array" do
  #       expect(response.body).to eq "[]"
  #     end
  #   end
  # end
  #
  # describe "GET 'search'" do
  #   it "is successful" do
  #     get :search, name: rosa.name
  #     expect(response.response_code).to eq 200
  #   end
  #
  #   it "returns json" do
  #     get :search, name: rosa.name
  #     expect(response.header['Content-Type']).to include 'application/json'
  #   end
  #
  #   it "fuzzy searches" do
  #     get :search, name: "Ros"
  #     expect(response.response_code).to eq 200
  #   end
  #
  #   context "return json object" do
  #     before :each do
  #       get :search, name: rosa.name
  #       @response = JSON.parse(response.body)
  #     end
  #
  #     it "has the right keys" do
  #       expect(@response.keys.sort).to eq keys
  #     end
  #
  #     it "has all of Rosa's info" do
  #       keys.each do |key|
  #         expect(@response[key]).to eq rosa[key]
  #       end
  #     end
  #   end
  #
  #   context "unsuccessful search" do
  #     before(:each) do
  #       get :search, name: "bubbles"
  #     end
  #     it "is successful" do
  #       expect(response).to be_successful
  #     end
  #
  #     it "returns a 204 (no content)" do
  #       expect(response.response_code).to eq 204
  #     end
  #
  #     it "expects the response body to be an empty array" do
  #       expect(response.body).to eq "[]"
  #     end
  #   end
  # end

end
