# frozen_string_literal: true

require_relative 'shot'

class Frame
  FULL_SCORE = 10

  def initialize(*marks)
    @shots = marks.map { |mark| Shot.new(mark) }
  end

  def score
    if strike? || spare?
      @shots.map(&:score).sum
    else
      @shots.take(2).map(&:score).sum
    end
  end

  def strike?
    @shots.first.score == FULL_SCORE
  end

  def spare?
    @shots.take(2).map(&:score).sum == FULL_SCORE
  end
end
