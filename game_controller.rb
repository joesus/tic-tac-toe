require 'pry-nav'

class GameController
  attr_accessor :params

  def initialize(params)
    self.params = params
  end

  def load_saved_game
    @game = TicTacToe.new
    @game.load_game(params)
    @game.computer_takes_turn unless @game.new_game?(params)
    @game.board.print_board(params, @game.message)
    @game.board.print_board(params, @game.message)
  end
end