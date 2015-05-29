require 'pry-nav'
require 'json'
require 'date'
require 'fileutils'
require_relative 'coordinates'
require_relative 'board'

class TicTacToe
  attr_accessor :board, :human_mark, :computer_mark, :turn, :message

  def initialize
    self.board = Board.new
  end

  def human_takes_turn
    input = gets
    if input.match(/save/)
      return save_game
    else
      move = Coordinates.new(input)
    end

    return if game_over?
    if @board.spot_open?(move)
      @board.array[move.x][move.y] = @human_mark
    else
      puts("That spot is taken, please enter a different coordinate")
      human_takes_turn
    end
    puts "Board after your move"
    board.print_board(@message)
  end

  def computer_takes_turn
    move = "#{rand(0..2)},#{rand(0..2)}\n"
    move = Coordinates.new(move)
    if @board.spot_open?(move)
      @human_mark == "X" ? @computer_mark = "O" : @computer_mark = "X"
      @board.array[move.x][move.y] = @computer_mark
    else
      computer_takes_turn
    end
  end

  def game_over?
    false unless human_won? || computer_won? || game_tied?
  end

  def human_won?
    lines = winning_lines
    lines.each do |array|
      return true if array.all? { |index| index == @human_mark }
    end
    false
  end

  def computer_won?
    lines = winning_lines
    lines.each do |array|
      return true if array.all? { |index| index == @computer_mark }
    end
    false
  end

  def game_tied?
    !@board.array.flatten.include?(" ")
  end

  def new_game?
    @board.array.flatten.all? { |x| x == " " }
  end

  def set_game_status_message
    if human_won?
      @message = "Congratulations, you win!"
    elsif computer_won?
      @message = "Sorry, the machines won, again."
    elsif game_tied?
      @message = "When man and machine fight, nobody wins"
    elsif new_game?
      @message = "Welcome to TicTacToe"
    else
      @message = "Board after computer's move"
    end
  end

  def load_game(game_info_json)
    game_info_json = parse_game_json(game_info_json)
    @board =          Board.new(game_info_json["board"])
    @computer_mark =  game_info_json["computer_mark"]
    @human_mark =     game_info_json["human_mark"]
    @turn =           game_info_json["turn"]
  end

  private
  
  def winning_lines
    lines = []
    # The across lines
    @board.array.each do |array|
      lines << array
    end
    # The lines down
    lines << [@board.array[0][0], @board.array[1][0], @board.array[2][0]]
    lines << [@board.array[0][1], @board.array[1][1], @board.array[2][1]]
    lines << [@board.array[0][2], @board.array[1][2], @board.array[2][2]]
    # The diagonals
    lines << [@board.array[0][0], @board.array[1][1], @board.array[2][2]]
    lines << [@board.array[0][2], @board.array[1][1], @board.array[2][0]]
    lines
  end

  def to_json
    hash = Hash.new
    hash[:board] = @board.array
    hash[:turn] = @turn
    hash[:human_mark] = @human_mark
    hash[:computer_mark] = @computer_mark
    { "json" => JSON.generate(hash) }
  end

  def parse_game_json(game_info_json)
    JSON.parse(game_info_json["json"])
  end
end
