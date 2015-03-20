require 'pry'

class Coordinates
  attr_accessor :x, :y

  def initialize(move)
    @x, @y = move.delete!("\n").split(",").map! { |string| string.to_i - 1 }
  end
end

class Board
  attr_accessor :array

  def initialize
    @array = Array.new(3) { Array.new(3) { " " } }
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

class TicTacToe
  attr_accessor :board, :human_mark, :computer_mark, :first_move

  def initialize
    self.board = Board.new
  end

  def play
    puts "Welcome to tic-tac-toe \n We'll be using a 3x3 grid to play, the top left corner being 1,1 and the bottom right corner being 3,3"
    puts "Would you like to be X's or O's"
    gets.include?("X" || "x") ? @human_mark = "X" : @human_mark = "O"
    puts "Would you like to go first? [Yes][y]"
    input = gets.downcase.strip
    input.include?("y") ? @first_move = true : @first_move = false

    if @first_move
      puts "Human goes first"
      until game_over?
        puts "Where would you like to go? Please enter your move in the form of a 2-digit coordinate, ex: 1,1"
        human_takes_turn
        break if game_over?
        computer_takes_turn
      end
    else
      puts "Computer goes first"
      until game_over?
        computer_takes_turn
        break if game_over?
        puts "Where would you like to go? Please enter your move in the form of a 2-digit coordinate, ex: 1,1"
        human_takes_turn
      end
    end
  end

  def human_takes_turn(move=Coordinates.new(gets))
    return if game_over?
    move ||= Coordinates.new(gets)
    if @board.spot_open?(move)
      @board.array[move.x][move.y] = @human_mark
    else
      puts("That spot is taken, please enter a different coordinate")
      new_move = Coordinates.new(gets)
      human_takes_turn(new_move)
    end
    puts "Board after your move"
    board.print_board
  end

  def computer_takes_turn
    return if game_over?
    move = "#{rand(0..2)},#{rand(0..2)}\n"
    move = Coordinates.new(move)
    if @board.spot_open?(move)
      @human_mark == "X" ? @computer_mark = "O" : @computer_mark = "X"
      @board.array[move.x][move.y] = @computer_mark
    else
      computer_takes_turn
    end
    puts "Board after computer's move"
    board.print_board
  end

  def game_over?
    switch = false
    lines = []
    # The across lines
    @board.array.each do |array|
      lines << array
    end
    # The lines down
    lines << @board.array.flatten.values_at(0,3,6)
    lines << @board.array.flatten.values_at(1,4,7)
    lines << @board.array.flatten.values_at(2,5,8)
    # The diagonals
    lines << @board.array.flatten.values_at(0,4,8)
    lines << @board.array.flatten.values_at(2,4,6)

    lines.each do |array|
      if array.all? { |index| index == @human_mark }
        switch = true
        puts "Congratulations, you win!"
        break
      elsif array.all? { |index| index == @computer_mark }
        switch = true
        puts "Sorry, the machines won, again."
        break
      elsif !@board.array.flatten.include?(" ")
        switch = true
        puts "When man and machine fight, nobody wins"
        break
      else
        switch = false
      end
    end
    switch
  end
end

game = TicTacToe.new
game.play