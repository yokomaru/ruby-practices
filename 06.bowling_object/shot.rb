# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(mark)
    @mark = mark
    @score = parse_score
  end

  private

  def parse_score
    @mark == 'X' ? 10 : @mark.to_i
  end
end
