# frozen_string_literal: true

require_relative 'shot'

class Frame
  FULL_SCORE = 10

  def initialize(first_mark, second_mark, third_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
    @shots = [@first_shot, @second_shot, @third_shot]
  end

  def score
    if strike? || spare?
      @shots.map(&:score).sum
    else
      @shots.take(2).map(&:score).sum
    end
  end

  def strike?
    @first_shot.score == FULL_SCORE
  end

  def spare?
    @shots.take(2).map(&:score).sum == FULL_SCORE
  end
end
