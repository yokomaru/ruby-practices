# frozen_string_literal: true

require_relative 'frame'

class Game
  FRAME_TIMES = 10

  def initialize(score_text)
    @frames = parse_score_text(score_text)
  end

  def score
    @frames.sum(&:score)
  end

  private

  def parse_score_text(score_text)
    scores = score_text.split(',').map { |score| score == 'X' ? 10 : score.to_i }
    Array.new(FRAME_TIMES) do
      frame = Frame.new(*scores[0, 2], scores[2])
      scores.shift(frame.strike? ? 1 : 2)
      frame
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.score
end
