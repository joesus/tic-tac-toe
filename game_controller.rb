require 'pry-nav'

class GameController
  attr_accessor :params

  def initialize(params)
    self.params = params
  end

  def load_saved_game
    @game = TicTacToe.new
    @game.load_game(params)
    @game.computer_takes_turn unless @game.new_game? || @game.game_over?
    @game.set_game_status_message
    @game.board.print_board(params, @game.message)
  end
end