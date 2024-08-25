# frozen_string_literal: true

class Shot
  STRIKE_SCORE = 10
  SPARE_SCORE = 10

  def initialize(mark)
    @mark = mark
  end

  def score
    @mark == 'X' ? STRIKE_SCORE : @mark.to_i
  end
end
