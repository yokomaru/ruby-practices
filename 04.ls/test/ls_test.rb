# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def setup
    @wd = FileUtils.pwd
  end

  def teardown
    FileUtils.cd(@wd)
  end

  def test_ls_nonexistent_directory_and_file
    FileUtils.cd("#{@wd}/test/test_directory_0")
    assert_equal '', `ruby #{@wd}/ls.rb`
  end

  def test_ls_specified_nonexistent_directory_and_file
    FileUtils.cd("#{@wd}/test/test_directory_1")
    expected = <<~LS_RESULT
      ls: test.rb: No such file or directory
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test.rb`
  end

  def test_ls_specified_multiple_nonexistent_directories_and_files
    FileUtils.cd("#{@wd}/test/test_directory_1")
    expected = <<~LS_RESULT
      ls: test.rb: No such file or directory
      ls: test_2.rb: No such file or directory
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test.rb test_2.rb`
  end

  def test_ls_one_file_exists
    FileUtils.cd("#{@wd}/test/test_directory_1")
    expected = <<~LS_RESULT
      test_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_two_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_2")
    expected = <<~LS_RESULT
      test_1.txt test_2.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_three_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_3")
    expected = <<~LS_RESULT
      test_1.txt test_2.txt test_3.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_four_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_4")
    expected = <<~LS_RESULT
      test_1.txt test_3.txt
      test_2.txt test_4.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_five_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_5")
    expected = <<~LS_RESULT
      test_1.txt test_3.txt test_5.txt
      test_2.txt test_4.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_six_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_6")
    expected = <<~LS_RESULT
      test_1.txt test_3.txt test_5.txt
      test_2.txt test_4.txt test_6.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_long_name_file_exists
    FileUtils.cd("#{@wd}/test/test_directory_long_file_name")
    expected = <<~LS_RESULT
      test_1_test_test_test_test_test_test_test_test_test_test_test_test_test.txt
      test_2.txt
      test_3.txt
      test_4.txt
      test_5.txt
      test_6.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_exsisting_directories_and_files
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      TEST_DIR      test
      TEST_FILE.txt test.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_specified_directory
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      test_file_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb TEST_DIR`
  end

  def test_ls_specified_multiple_directories
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      TEST_DIR:
      test_file_1.txt

      test:
      test_file_2.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb TEST_DIR test`
  end

  def test_ls_specified_directory_and_file
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      test.txt

      TEST_DIR:
      test_file_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test.txt TEST_DIR`
  end

  def test_ls_specified_directory_and_nonexistent_file
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      ls: test_nothing_file_1.txt: No such file or directory
      TEST_DIR:
      test_file_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test_nothing_file_1.txt TEST_DIR`
  end

  def test_ls_specified_file_and_empty_directory
    FileUtils.cd(@wd.to_s)
    expected = <<~LS_RESULT
      ls.rb

      test/test_directory_0:
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb ls.rb test/test_directory_0`
  end

  def test_ls_specified_directory_and_file_and_nonexistent_file
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      ls: test_nothing_file_1.txt: No such file or directory
      test.txt

      TEST_DIR:
      test_file_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test_nothing_file_1.txt test.txt TEST_DIR`
  end

  def test_ls_multiple_directories_and_multiple_files_and_multiple_nonexistent_files
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      ls: test_nothing_file_1.txt: No such file or directory
      ls: test_nothing_file_2.txt: No such file or directory
      TEST_FILE.txt test.txt

      TEST_DIR:
      test_file_1.txt

      test:
      test_file_2.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test_nothing_file_1.txt test_nothing_file_2.txt test.txt TEST_FILE.txt TEST_DIR test`
  end

  def test_ls_multi_byte_file_name
    FileUtils.cd("#{@wd}/test/test_directory_multi_byte_file_name")
    expected = <<~LS_RESULT
      test_1_テスト.txt    test_3.txt           test_5.txt
      test_2.txt           test_4.txt           test_6.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_option_a
    FileUtils.cd("#{@wd}/test/test_directory_0")
    expected = <<~LS_RESULT
      .  ..
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb -a`
  end

  def test_ls_option_a_with_dotfile
    FileUtils.cd("#{@wd}/test/test_directory_dotfile")
    expected = <<~LS_RESULT
      .          test_1.txt test_4.txt
      ..         test_2.txt test_5.txt
      .testfile  test_3.txt test_6.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb -a`
  end

  def test_ls_option_r_with_option_a
    FileUtils.cd("#{@wd}/test/test_directory_dotfile")
    expected = <<~LS_RESULT
      test_6.txt test_3.txt .testfile
      test_5.txt test_2.txt ..
      test_4.txt test_1.txt .
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb -a -r`
  end

  def test_ls_option_l
    FileUtils.cd("#{@wd}/test/test_directory_dotfile")
    # xxxxxxxxxxx は管理者名の名前のためマスク
    # 実行時に変更する
    expected = <<~LS_RESULT
      total 0
      -rw-r--r--  1 xxxxxxxxxxx  staff  0  4  8 14:27 test_1.txt
      -rw-r--r--  1 xxxxxxxxxxx  staff  0  4  8 14:27 test_2.txt
      -rw-r--r--  1 xxxxxxxxxxx  staff  0  4  8 14:27 test_3.txt
      -rw-r--r--  1 xxxxxxxxxxx  staff  0  4  8 14:27 test_4.txt
      -rw-r--r--  1 xxxxxxxxxxx  staff  0  4  8 14:27 test_5.txt
      -rw-r--r--  1 xxxxxxxxxxx  staff  0  4  8 14:27 test_6.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb -l`
  end

  def test_ls_option_l_specify_file
    FileUtils.cd(@wd.to_s)
    # xxxxxxxxxxx は管理者名の名前のためマスク
    # 実行時に変更する
    expected = <<~LS_RESULT
      -rwxr-xr-x  1 xxxxxxxxxxx  staff  249  4 23 17:10 test/test_directory_option_l/test_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb -l test/test_directory_option_l/test_1.txt`
  end

  def test_ls_option_l_specify_directory
    FileUtils.cd(@wd.to_s)
    # xxxxxxxxxx は管理者名の名前のためマスク
    # 実行時に変更する
    expected = <<~LS_RESULT
      total 16
      -rwxr-xr-x  1 xxxxxxxxxxx  staff  249  4 23 17:10 test_1.txt
      -rwxr-xr-x  1 xxxxxxxxxxx  staff  249  4 23 17:10 test_2.txt
      drwxr-xr-x  3 xxxxxxxxxxx  staff   96  4 23 17:18 test_dir
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb -l test/test_directory_option_l`
  end
end
