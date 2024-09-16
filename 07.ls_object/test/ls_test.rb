# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../bin/ls'

class LsTest < Minitest::Test
  def test_run
    assert_equal 'test', Ls.run
  end
end
