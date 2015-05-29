require_relative '../tic_tac_toe'
require 'spec_helper'
require 'rspec/expectations'

describe TicTacToe do

  let(:new_game_json)       { {"json" => "{\"board\":[[\" \", \" \", \" \"], [\" \", \" \", \" \"], [\" \", \" \", \" \"]], \"turn\":\"human\", \"human_mark\":\"X\", \"computer_mark\":\"O\"}"} }
  let(:human_wins_json)     { {"json" => "{\"board\":[[\"X\", \"X\", \"X\"], [\" \", \" \", \" \"], [\" \", \" \", \" \"]], \"turn\":\"human\", \"human_mark\":\"X\", \"computer_mark\":\"O\"}"} }
  let(:computer_wins_json)  { {"json" => "{\"board\":[[\"O\", \"O\", \"O\"], [\" \", \" \", \" \"], [\" \", \" \", \" \"]], \"turn\":\"human\", \"human_mark\":\"X\", \"computer_mark\":\"O\"}"} }
  let(:game_tied_json)      { {"json" => "{\"board\":[
    [\"O\", \"O\", \"X\"],[\"X\", \"O\", \"O\"],[\"O\", \"X\", \"X\"]], \"turn\":\"human\", \"human_mark\":\"X\", \"computer_mark\":\"O\"}"} }

  describe 'new_game?' do
    context 'with new game params' do

      before do
        subject.load_game(new_game_json)
      end

      it 'returns true' do
        expect(subject.new_game?).to be true
      end
    end

    context 'with human wins params' do

      before do
        subject.load_game(human_wins_json)
      end
      it 'returns false' do
        expect(subject.new_game?).to be false
      end
    end
  end

  describe 'set_game_status_message' do
    context 'when new game' do

      it 'Welcome to TicTacToe' do |description|
        expect(subject.set_game_status_message).to match description.description
      end
    end

    context 'when human wins' do
      before do
        subject.load_game(human_wins_json)
      end

      it 'Congratulations, you win!' do |description|
        expect(subject.set_game_status_message).to match description.description
      end
    end

    context 'when computer wins' do
      before do
        subject.load_game(computer_wins_json)
      end

      it 'Sorry, the machines won, again.' do |description|
        expect(subject.set_game_status_message).to match description.description
      end
    end

    context 'when game ties' do
      before do
        subject.load_game(game_tied_json)
      end

      it 'When man and machine fight, nobody wins' do |description|
        expect(subject.set_game_status_message).to match description.description
      end
    end
  end
end