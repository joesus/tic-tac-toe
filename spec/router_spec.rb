require_relative '../router'
require 'spec_helper'
require 'rspec/expectations'

describe Router do

  before :each do
    @router = Router.new
  end

  describe "#setup_routes" do
    before :each do
      @router.setup_routes
    end

    it "creates a get_map with a hash" do
      expect(@router.get_map).to be_an_instance_of Hash
    end

    it "creates a get_map with hash keys that are routes" do
      expect(@router.get_map.keys.first).to match(/^\/.*/)
    end

    it "creates a get_map with hash values that match the convention: controller#method" do
      expect(@router.get_map.values.first).to match(/.*[#].*/)
    end
  end

  describe "#create_controller" do
    # how do I test this...
  end
end