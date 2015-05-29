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

  def play
    puts "Welcome to tic-tac-toe would you like to play a new game or load a saved game?[n][s]"
    new_or_saved = gets
    if new_or_saved.downcase.match("s")
      unless Dir.glob('*.json').empty?
        load_saved_game
      else
        puts "Sorry, there are no saved games"
        setup_new_game
      end
    else
      setup_new_game
    end
    resume_game
  end

  def setup_new_game
    # Reads URL input
    binding.pry
    puts "Welcome to tic-tac-toe \n We'll be using a 3x3 grid to play, the top left corner being 1,1 and the bottom right corner being 3,3"
    puts "Save your game at any time by typing save"
    puts "Would you like to be X's or O's"
    gets.downcase.include?("x") ? @human_mark = "X" : @computer_mark = "O"
    puts "Would you like to go first? [Yes][y]"
    input = gets.downcase.strip
    input.include?("y") ? @turn = 'human' : @turn = 'computer'
  end

  # def resume_game
  #   until game_over?
  #     case @turn
  #     when 'human'
  #       puts "Human's turn"
  #       puts "Where would you like to go? Please enter your move in the form of a 2-digit coordinate, ex: 1,1"
  #       human_takes_turn
  #       break if game_over?
  #       @turn = 'computer'
  #     when 'computer'
  #       puts "Computer's turn"
  #       computer_takes_turn
  #       break if game_over?
  #       puts "Where would you like to go? Please enter your move in the form of a 2-digit coordinate, ex: 1,1"
  #       @turn = 'human'
  #     end
  #   end
  # end

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

  def save_game
    File.open("#{get_filename}.json", 'w+') { |file| file.write(to_json) }
    puts "Look forward to seeing you again!"
    exit
  end

  def get_filename
    game_name = nil

    while game_name.nil? do
      puts "Please enter a name for your saved game. ex: 'my-saved-game'"
      game_name = gets.chomp
      if game_exists?(game_name)
        puts "Would you like to overwrite the existing game - #{game_name} ? [y][n] Warning: this is irreversible."
        if !gets.downcase.match("y")
          game_name = nil
        end
      end
    end
    game_name
  end

  def game_exists?(game_name)
    !Dir.glob("#{game_name}.json").empty?
  end

  def load_saved_game(params=nil)
    puts "Please select from the list of saved games"
    Dir.glob('*.json').each_with_index do |game, index|
      puts "[#{index}] #{game}"
    end
    selected_game = Dir.glob('*.json')[gets.to_i]
    puts selected_game
    game_info_json = params || JSON.parse(IO.read(selected_game))
    load_game(game_info_json)
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
