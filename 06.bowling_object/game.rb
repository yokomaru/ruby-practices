# frozen_string_literal: true

require_relative 'frame'

class Game
  FRAME_TIMES = 10

  def initialize(score_text)
    @frames = generate_frames(score_text)
  end

  def score
    @frames.sum(&:score)
  end

  private

  def generate_frames(score_text)
    scores = score_text.split(',')
    Array.new(FRAME_TIMES) do
      frame = Frame.new(*scores[0, 2], scores[2])
      scores.shift(frame.strike? ? 1 : 2)
      frame
    end
  end
end
