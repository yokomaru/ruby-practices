# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark, third_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    if @first_shot.score == Shot::STRIKE_SCORE || @first_shot.score + @second_shot.score == Shot::SPARE_SCORE
      [@first_shot, @second_shot, @third_shot].map(&:score).sum
    else
      [@first_shot, @second_shot].map(&:score).sum
    end
  end
end
