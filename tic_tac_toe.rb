require 'pry-nav'
require 'json'
require 'date'
require 'fileutils'
require_relative 'coordinates'
require_relative 'board'

class TicTacToe
  attr_accessor :board, :player_one, :player_two, :turn, :message

  def initialize
    self.board = Board.new
  end

  def game_over?
    if human_won? || computer_won? || game_tied?
      true
    else
      false
    end
  end

  def human_won?
    lines = winning_lines
    lines.each do |array|
      return true if array.all? { |index| index == @player_one }
    end
    false
  end

  def computer_won?
    lines = winning_lines
    lines.each do |array|
      return true if array.all? { |index| index == @player_two }
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
      @message = "X's win!"
    elsif computer_won?
      @message = "O's win!"
    elsif game_tied?
      @message = "A perfect compromise. Everyone loses."
    elsif new_game?
      @message = "Welcome to TicTacToe"
    else
      @message = "Your move"
    end
  end

  def load_game(params)
    game_info_json = parse_game_json(params)
    @board =          Board.new(game_info_json["board"])
    @player_two =  game_info_json["player_two"]
    @player_one =     game_info_json["player_one"]
    @turn =           game_info_json["turn"]
  end

  def change_player(params)
    new_params = parse_game_json(params)
    new_params["turn"] = next_player(params)
    params["json"] = new_params.to_s.gsub("=>", ":")
    params
  end

  def next_player(params)
    json_params = parse_game_json(params)
    json_params["turn"] == "player_one" ? json_params["turn"] = "player_two" : json_params["turn"] = "player_one"
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
    hash[:player_one] = @player_one
    hash[:player_two] = @player_two
    { "json" => JSON.generate(hash) }
  end

  def parse_game_json(game_info_json)
    JSON.parse(game_info_json["json"])
  end
end
