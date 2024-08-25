# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../frame'

class FrameTest < Minitest::Test
  def test_normal_score_frame
    frame_second = Frame.new('0', '7', 'X')
    assert_equal 7, frame_second.score
  end

  def test_spare_frame
    frame_second = Frame.new('1', '9', 'X')
    assert_equal 20, frame_second.score
  end

  def test_strike_frame
    frame_first = Frame.new('X', '0', '5')
    assert_equal 15, frame_first.score
  end

  def test_last_full_strike_frame
    frame_first = Frame.new('X', 'X', 'X')
    assert_equal 30, frame_first.score
  end
end
