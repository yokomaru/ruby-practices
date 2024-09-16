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

  def test_display_dot_file
    lscommand = LsCommand.new('test_dir3')
    assert_equal 'dir test.txt test_2.txt', lscommand.display
  end

  def test_display_match_dot_file
    params = { dot_match: true }
    lscommand = LsCommand.new('test_dir3', **params)
    assert_equal '. .. .test dir test.txt test_2.txt', lscommand.display
  end

  def test_display_reverse_sort_file
    params = { reverse: true, dot_match: false }
    lscommand = LsCommand.new('test_dir3', **params)
    assert_equal 'test_2.txt test.txt dir', lscommand.display
  end

  def test_display_dot_match_and_reverse_sort_file
    params = { reverse: true, dot_match: true }
    lscommand = LsCommand.new('test_dir3', **params)
    assert_equal 'test_2.txt test.txt dir .test .. .', lscommand.display
  end
end
