# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/ls_command'

class LsCommandTest < Minitest::Test
  def test_display_a_file
    lscommand = LsCommand.new('test_dir')
    assert_equal 'test.txt', lscommand.display
  end

  def test_display_two_files
    lscommand = LsCommand.new('test_dir2')
    assert_equal 'test.txt test_2.txt', lscommand.display
  end
end
