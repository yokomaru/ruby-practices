# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/ls_file'

class LsFilePathTest < Minitest::Test
  def test_name
    file = LsFile.new('test.txt')
    assert_equal 'test.txt', file.name
  end
end
