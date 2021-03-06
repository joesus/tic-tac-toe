require_relative '../board'
require 'spec_helper'
require 'rspec/expectations'

describe Board do

  before :each do
    @top_left = Coordinates.new("0,0")
    @top_right = Coordinates.new("0,2")
  end

  describe "a new board" do

    it 'should be three arrays' do
      expect(subject.array.all? {|component| component.class == Array }).to be true
      expect(subject.array.size).to be 3
    end

    it 'should have empty cells' do
      expect(subject.array.flatten.all? { |cell| cell == " "}).to be true
    end
  end

  describe "spot_open?" do

    it 'should return true when a spot is open' do
      expect(subject.spot_open?(@top_right)).to be true
    end

    it 'should return false when a spot is taken' do
      subject.array[0][0] = "X"
      expect(subject.spot_open?(@top_left)).to be false
    end
  end
end