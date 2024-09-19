# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/ls_command'

class LsCommandTest < Minitest::Test
  def test_display_a_file
    ls_command = LsCommand.new('test/test_dir/test_one_file')
    assert_equal 'test.txt', ls_command.display
  end

  def test_display_files
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files')
    assert_equal 'dir        test.txt   test_2.txt', ls_command.display
  end

  def test_display_match_dot_files
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal '.          ..         .test      dir        test.txt   test_2.txt', ls_command.display
  end

  def test_display_reverse_sort_files
    params = { reverse: true, dot_match: false }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal 'test_2.txt test.txt   dir', ls_command.display
  end

  def test_display_dot_match_and_reverse_sort_file
    params = { reverse: true, dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal 'test_2.txt test.txt   dir        .test      ..         .', ls_command.display
  end

  def test_display_long_format_file
    params = { long_format: true }
    ls_command = LsCommand.new('test/test_dir/test_one_file', **params)
    expected = <<~LS_RESULT.chomp
      total 8
      -rw-r--r--  1 suzukiyouko  staff  10  9 15 14:34 test.txt
    LS_RESULT
    assert_equal expected, ls_command.display
  end

  def test_display_long_format_and_dot_match_file
    params = { long_format: true, dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    expected = <<~LS_RESULT.chomp
      total 16
      drwxr-xr-x  6 suzukiyouko  staff  192  9 16 15:18 .
      drwxr-xr-x  5 suzukiyouko  staff  160  9 19 18:20 ..
      -rw-r--r--  1 suzukiyouko  staff    0  9 16 15:14 .test
      drwxr-xr-x  2 suzukiyouko  staff   64  9 16 15:18 dir
      -rw-r--r--  1 suzukiyouko  staff   10  9 16 15:14 test.txt
      -rw-r--r--  1 suzukiyouko  staff   10  9 16 15:14 test_2.txt
    LS_RESULT
    assert_equal expected, ls_command.display
  end

  def test_display_long_format_and_dot_match_and_reverse_file
    params = { reverse: true, long_format: true, dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    expected = <<~LS_RESULT.chomp
      total 16
      -rw-r--r--  1 suzukiyouko  staff   10  9 16 15:14 test_2.txt
      -rw-r--r--  1 suzukiyouko  staff   10  9 16 15:14 test.txt
      drwxr-xr-x  2 suzukiyouko  staff   64  9 16 15:18 dir
      -rw-r--r--  1 suzukiyouko  staff    0  9 16 15:14 .test
      drwxr-xr-x  5 suzukiyouko  staff  160  9 19 18:20 ..
      drwxr-xr-x  6 suzukiyouko  staff  192  9 16 15:18 .
    LS_RESULT
    assert_equal expected, ls_command.display
  end

  def test_display_width_eighty
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal '.          ..         .test      dir        test.txt   test_2.txt', ls_command.display
  end

  def test_display_width_fourty
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', width: 40, **params)
    expected = <<~LS_RESULT.chomp
      .          .test      test.txt
      ..         dir        test_2.txt
    LS_RESULT
    assert_equal expected, ls_command.display
  end

  def test_display_width_thirty
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', width: 30, **params)
    expected = <<~LS_RESULT.chomp
      .          dir
      ..         test.txt
      .test      test_2.txt
    LS_RESULT
    assert_equal expected, ls_command.display
  end

  def test_display_width_twenty
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', width: 20, **params)
    expected = <<~LS_RESULT.chomp
      .
      ..
      .test
      dir
      test.txt
      test_2.txt
    LS_RESULT
    assert_equal expected, ls_command.display
  end
end
