# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/ls_command'

class LsCommandTest < Minitest::Test
  def test_display_a_file
    ls_command = LsCommand.new('test_dir')
    assert_equal 'test.txt', ls_command.display
  end

  def test_display_two_files
    ls_command = LsCommand.new('test_dir2')
    assert_equal 'test.txt test_2.txt', ls_command.display
  end

  def test_display_dot_file
    ls_command = LsCommand.new('test_dir3')
    assert_equal 'dir test.txt test_2.txt', ls_command.display
  end

  def test_display_match_dot_file
    params = { dot_match: true }
    ls_command = LsCommand.new('test_dir3', **params)
    assert_equal '. .. .test dir test.txt test_2.txt', ls_command.display
  end

  def test_display_reverse_sort_file
    params = { reverse: true, dot_match: false }
    ls_command = LsCommand.new('test_dir3', **params)
    assert_equal 'test_2.txt test.txt dir', ls_command.display
  end

  def test_display_dot_match_and_reverse_sort_file
    params = { reverse: true, dot_match: true }
    ls_command = LsCommand.new('test_dir3', **params)
    assert_equal 'test_2.txt test.txt dir .test .. .', ls_command.display
  end

  def test_display_long_format_file
    params = { long_format: true }
    ls_command = LsCommand.new('test_dir', **params)
    expected = "total 8\n-rw-r--r-- 1 suzukiyouko staff 10  9 15 14:34 test.txt"
    assert_equal expected, ls_command.display
  end

  def test_display_long_format_and_all_file
    params = { long_format: true , dot_match: true }
    ls_command = LsCommand.new('test_dir2', **params)
    expected = "total 16
drwxr-xr-x 4 suzukiyouko staff 128  9 15 15:30 .
drwxr-xr-x 10 suzukiyouko staff 320  9 16 15:14 ..
-rw-r--r-- 1 suzukiyouko staff 10  9 15 15:30 test.txt
-rw-r--r-- 1 suzukiyouko staff 10  9 15 15:30 test_2.txt"
    assert_equal expected, ls_command.display
  end


  def test_display_long_format_and_all_and_reverse_file
    params = { reverse: true, long_format: true , dot_match: true }
    ls_command = LsCommand.new('test_dir2', **params)
    expected = "total 16
-rw-r--r-- 1 suzukiyouko staff 10  9 15 15:30 test_2.txt
-rw-r--r-- 1 suzukiyouko staff 10  9 15 15:30 test.txt
drwxr-xr-x 10 suzukiyouko staff 320  9 16 15:14 ..
drwxr-xr-x 4 suzukiyouko staff 128  9 15 15:30 ."
    assert_equal expected, ls_command.display
  end
end
