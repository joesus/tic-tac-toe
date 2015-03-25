class Board
  attr_accessor :array

  def initialize(board=Array.new(3) { Array.new(3) { " " }})
    @array = board
  end

  def print_board
    @array.each do |nested_array|
      print "#{nested_array}, \n"
    end
  end

  def spot_open?(spot)
    @array[spot.x][spot.y] == " " ? true : false
  end
end