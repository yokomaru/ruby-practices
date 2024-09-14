# frozen_string_literal: true

require_relative 'game'

class Bowling
  def initialize(game)
    @game = game
  end

  def run
    puts @game.score
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  Bowling.new(game).run
end
