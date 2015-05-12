require_relative '../coordinates'
require 'spec_helper'
require 'rspec/expectations'

describe Coordinates do

  describe "coordinates" do

    before :each do
      @coordinate = Coordinates.new("0,1")
    end

    it "acts like a tuple" do
      expect(@coordinate.x).to be 0
      expect(@coordinate.y).to be 1
    end
  end


end