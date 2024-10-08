# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../shot'

class ShotTest < Minitest::Test
  def test_shot
    shot_x = Shot.new('X')
    assert_equal 10, shot_x.score

    shot_one = Shot.new('1')
    assert_equal 1, shot_one.score
  end
end
