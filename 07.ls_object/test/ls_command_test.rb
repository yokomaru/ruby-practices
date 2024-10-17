# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/ls_command'

class LsCommandTest < Minitest::Test
  def test_display_a_file
    ls_command = LsCommand.new('test/test_dir/test_one_file')
    assert_equal 'test.txt', ls_command.formatted_output
  end

  def test_display_files
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files')
    assert_equal 'dir        test.txt   test_2.txt', ls_command.formatted_output
  end

  def test_display_match_dot_files
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal '.          ..         .test      dir        test.txt   test_2.txt', ls_command.formatted_output
  end

  def test_display_reverse_sort_files
    params = { reverse: true, dot_match: false }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal 'test_2.txt test.txt   dir', ls_command.formatted_output
  end

  def test_display_dot_match_and_reverse_sort_file
    params = { reverse: true, dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal 'test_2.txt test.txt   dir        .test      ..         .', ls_command.formatted_output
  end

  def test_display_long_format_file
    # Output example
    #  total 8
    #  -rw-r--r--  1 username  staff  10  9 15 14:34 test.txt
    path = 'test/test_dir/test_one_file'
    params = { long_format: true }
    expected = `ls -l #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_long_format_and_dot_match_file
    # Output example
    # total 16
    # drwxr-xr-x  6 username  staff  192  9 16 15:18 .
    # drwxr-xr-x  5 username  staff  160  9 19 18:20 ..
    # -rw-r--r--  1 username  staff    0  9 16 15:14 .test
    # drwxr-xr-x  2 username  staff   64  9 16 15:18 dir
    # -rw-r--r--  1 username  staff   10  9 16 15:14 test.txt
    # -rw-r--r--  1 username  staff   10  9 16 15:14 test_2.txt
    path = 'test/test_dir/test_include_dir_and_dot_files'
    params = { long_format: true, dot_match: true }
    expected = `ls -al #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_long_format_and_dot_match_and_reverse_file
    # Output example
    # total 16
    #  -rw-r--r--  1 username  staff   10  9 16 15:14 test_2.txt
    #  -rw-r--r--  1 username  staff   10  9 16 15:14 test.txt
    #  drwxr-xr-x  2 username  staff   64  9 16 15:18 dir
    #  -rw-r--r--  1 username  staff    0  9 16 15:14 .test
    #  drwxr-xr-x  5 username  staff  160  9 19 18:20 ..
    #  drwxr-xr-x  6 username  staff  192  9 16 15:18 .
    params = { reverse: true, long_format: true, dot_match: true }
    path = 'test/test_dir/test_include_dir_and_dot_files'
    expected = `ls -arl #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_width_eighty
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', **params)
    assert_equal '.          ..         .test      dir        test.txt   test_2.txt', ls_command.formatted_output
  end

  def test_display_width_fourty
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', width: 40, **params)
    expected = <<~LS_RESULT.chomp
      .          .test      test.txt
      ..         dir        test_2.txt
    LS_RESULT
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_width_thirty
    params = { dot_match: true }
    ls_command = LsCommand.new('test/test_dir/test_include_dir_and_dot_files', width: 30, **params)
    expected = <<~LS_RESULT.chomp
      .          dir
      ..         test.txt
      .test      test_2.txt
    LS_RESULT
    assert_equal expected, ls_command.formatted_output
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
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_special_permission
    # Output example
    # total 0
    # -rwxr-sr-x  1 username  staff  0 10  7 21:46 set_group_id_file.txt
    # -rwxr-Sr-x  1 username  staff  0 10  7 22:05 set_group_id_file_not_x_permission.txt
    # -r-Sr-Sr-T  1 username  staff  0 10 17 00:18 set_user_id_and_group_id_and_sticky_bit_permission.txt
    # -rwsr-sr-x  1 username  staff  0 10 17 00:17 set_user_id_and_group_id_permission.txt
    # -rwsr-xr-x  1 username  staff  0 10  7 21:46 set_user_id_file.txt
    # -r-Sr-xr-x  1 username  staff  0 10  7 22:05 set_user_id_file_not_x_permission.txt
    # -rwxr-xr-t  1 username  staff  0 10  7 21:46 sticky_bit_file.txt
    # -rwxr-xr-T  1 username  staff  0 10  7 21:51 sticky_bit_file_not_x_permission.txt
    params = { long_format: true }
    path = 'test/test_dir/special_permission_dir'
    `chmod 2755 #{path}/set_group_id_file.txt` # group permissionに実行権限xと特殊権限を付与
    `chmod 2745 #{path}/set_group_id_file_not_x_permission.txt` # group permissionの実行権限xを外し特殊権限を付与
    `chmod 4755 #{path}/set_user_id_file.txt` # owner permissionに実行権限xと特殊権限を付与
    `chmod 4455 #{path}/set_user_id_file_not_x_permission.txt` # owner permissionの実行権限xを外し特殊権限を付与
    `chmod 1755 #{path}/sticky_bit_file.txt` # other permissionに実行権限xと特殊権限を付与
    `chmod 1754 #{path}/sticky_bit_file_not_x_permission.txt` # other permissionの実行権限xを外し特殊権限を付与
    `chmod 6755 test/test_dir/special_permission_dir/set_user_id_and_group_id_permission.txt`
    `chmod 7444 test/test_dir/special_permission_dir/set_user_id_and_group_id_and_sticky_bit_permission.txt`
    expected = `ls -l #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_some_file_types
    # Output example
    # total 0
    # drwxr-xr-x  2 username  staff   64 10  7 23:12 test_dir
    # -rw-r--r--  1 username  staff    0 10  7 23:07 test_file.txt
    # lrwxr-xr-x  1 username  staff  102 10  7 22:59 test_link -> ../07.ls_object/test/test_dir/link_dir/link_test.txt # フルパスのため省略
    # prw-r--r--  1 username  staff    0 10  8 01:17 testfile
    params = { long_format: true }
    path = 'test/test_dir/file_type_dir'
    # パイプファイルの作成
    `mkfifo test/test_dir/file_type_dir/test_fifo_file` unless File.exist?('test/test_dir/file_type_dir/test_fifo_file')
    expected = `ls -l #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_block_device_file_type
    # Output example
    # brw-r-----  1 root  operator  0x1000004  9  8 09:43 /dev/disk1
    params = { long_format: true }
    path = '/dev/disk1'
    expected = `ls -l #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_character_device_file_file_type
    # Output example
    # total 0
    # crw-rw-rw-  1 root  wheel  0x3000002 10  8 01:26 /dev/null
    params = { long_format: true }
    path = '/dev/null'
    expected = `ls -l #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end

  def test_display_local_domain_sockets_file_type
    # Output example
    # srw-------  1 root  daemon  0  9  8 09:43 /var/run/vpncontrol.sock
    params = { long_format: true }
    path = '/var/run/vpncontrol.sock'
    expected = `ls -l #{path}`.chomp
    ls_command = LsCommand.new(path, **params)
    assert_equal expected, ls_command.formatted_output
  end
end
