# frozen_string_literal: true

require_relative 'frame'

class Game
  FRAME_TIMES = 10

  def initialize(score_text)
    @score_text = score_text
  end

  def score
    scores = parse_score_text(@score_text)
    total_point = 0
    GAME_TIMES.times do
      frame = Frame.new(scores[0], scores[1], scores[2])
      total_point += frame.score
      scores.shift(scores[0] == Shot::STRIKE_SCORE ? 1 : 2)
    end
    total_point
  end

  private

  def parse_score_text(score_text)
    score_text.split(',').map { |score| score == 'X' ? Shot::STRIKE_SCORE : score.to_i }
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.score
end
