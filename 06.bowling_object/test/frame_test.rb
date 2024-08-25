# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../frame'

class FrameTest < Minitest::Test
  def test_frame
    frame_first = Frame.new('X')
    assert_equal 10, frame_first.score

    frame_second = Frame.new('1', '9')
    assert_equal 10, frame_second.score

    frame_third = Frame.new('1', '9', 'X')
    assert_equal 20, frame_third.score
  end
end
