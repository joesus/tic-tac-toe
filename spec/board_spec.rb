require_relative '../board'
require 'spec_helper'
require 'rspec/expectations'

describe Board do

  before :each do
    @board = Board.new
    @top_left = Coordinates.new("0,0")
    @top_right = Coordinates.new("0,2")
  end

  subject { @board }

  describe "a new board" do

    it 'should be three arrays' do
      expect(@board.array.all? {|component| component.class == Array }).to be true
      expect(@board.array.size).to be 3
    end

    it 'should have empty cells' do
      expect(@board.array.flatten.all? { |cell| cell == " "}).to be true
    end
  end

  describe "spot_open?" do

    it 'should return true when a spot is open' do
      expect(@board.spot_open?(@top_right)).to be true
    end

    it 'should return false when a spot is taken' do
      @board.array[0][0] = "X"
      expect(@board.spot_open?(@top_left)).to be false
    end
  end
end