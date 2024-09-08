# frozen_string_literal: true

require_relative 'shot'

class Frame
  FULL_SCORE = 10

  def initialize(first_mark, second_mark, third_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    if strike? || spare?
      [@first_shot, @second_shot, @third_shot].map(&:score).sum
    else
      [@first_shot, @second_shot].map(&:score).sum
    end
  end

  def strike?
    @first_shot.score == FULL_SCORE
  end

  def spare?
    @first_shot.score + @second_shot.score == FULL_SCORE
  end
end
