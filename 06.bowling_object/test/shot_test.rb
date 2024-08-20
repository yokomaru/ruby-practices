require 'minitest/autorun'
require_relative 'shot'

class ShotTest < Minitest::Test
  def test_shot
    shot_x = Shot.new('X')
    assert_equal 'X', shot_x.mark
    assert_equal 10, shot_x.score

    shot_one = Shot.new('1')
    assert_equal '1', shot_one.mark
    assert_equal 1, shot_one.score
  end
end
