class Coordinates
  attr_accessor :x, :y

  def initialize(move)
    @x, @y = move.chomp.split(",").map! { |string| string.to_i - 1 }
  end
end