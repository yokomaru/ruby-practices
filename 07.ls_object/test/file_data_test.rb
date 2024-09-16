# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/file_data'

class LsFilePathTest < Minitest::Test
  def test_name
    file = FileData.new('test.txt')
    assert_equal 'test.txt', file.name
  end
end
