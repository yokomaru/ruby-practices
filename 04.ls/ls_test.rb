# frozen_string_literal: true

require 'minitest/autorun'
require 'debug'
require_relative '../04.ls/ls'

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
    assert_equal "ls: test.rb: No such file or directory\n", `ruby #{@wd}/ls.rb test.rb`
  end

  def test_ls_specified_multiple_nonexistent_directories_and_files
    FileUtils.cd("#{@wd}/test/test_directory_1")
    assert_equal "ls: test.rb: No such file or directory\nls: test_2.rb: No such file or directory\n", `ruby #{@wd}/ls.rb test.rb test_2.rb`
  end

  def test_ls_one_file_exists
    FileUtils.cd("#{@wd}/test/test_directory_1")
    assert_equal "test_1.txt\n", `ruby #{@wd}/ls.rb`
  end

  def test_ls_two_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_2")
    assert_equal "test_1.txt test_2.txt\n", `ruby #{@wd}/ls.rb`
  end

  def test_ls_three_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_3")
    assert_equal "test_1.txt test_2.txt test_3.txt\n", `ruby #{@wd}/ls.rb`
  end

  def test_ls_four_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_4")
    assert_equal "test_1.txt test_3.txt\ntest_2.txt test_4.txt\n", `ruby #{@wd}/ls.rb`
  end

  def test_ls_five_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_5")
    assert_equal "test_1.txt test_3.txt test_5.txt\ntest_2.txt test_4.txt \n", `ruby #{@wd}/ls.rb`
  end

  def test_ls_six_files_exist
    FileUtils.cd("#{@wd}/test/test_directory_6")
    assert_equal "test_1.txt test_3.txt test_5.txt\ntest_2.txt test_4.txt test_6.txt\n", `ruby #{@wd}/ls.rb`
  end

  def test_ls_long_name_file_exists
    FileUtils.cd("#{@wd}/test/test_directory_long_file_name")
    expected = <<~LS_RESULT
      test_1_test_test_test_test_test_test_test_test_test_test_test_test_test.txt
      test_2.txt#{'                                                                 '}
      test_3.txt#{'                                                                 '}
      test_4.txt#{'                                                                 '}
      test_5.txt#{'                                                                 '}
      test_6.txt#{'                                                                 '}
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_exsisting_directories_and_files
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      TEST_DIR      test#{'         '}
      TEST_FILE.txt test.txt#{'     '}
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end

  def test_ls_specified_directory
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    assert_equal "test_file_1.txt\n", `ruby #{@wd}/ls.rb TEST_DIR`
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

  def test_ls_specified_multiple_directories_and_file
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      test.txt

      TEST_DIR:
      test_file_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test.txt TEST_DIR`
  end

  def test_ls_specified_multiple_directories_and_nonexistent_file
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      ls: test_nothing_file_1.txt: No such file or directory
      TEST_DIR:
      test_file_1.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test_nothing_file_1.txt TEST_DIR`
  end

  def test_ls_multiple_directory_and_file_and_dose_not_exist_file_specify
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      ls: test_nothing_file_1.txt: No such file or directory
      test.txt

      TEST_DIR:
      test_file_1.txt

      test:
      test_file_2.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test_nothing_file_1.txt test.txt TEST_DIR test`
  end

  def test_ls_multiple_directory_and_multiple_file_and_multiple_dose_not_exist_file_specify
    FileUtils.cd("#{@wd}/test/test_directory_exist_files_and_directories")
    expected = <<~LS_RESULT
      ls: test_nothing_file_1.txt: No such file or directory
      ls: test_nothing_file_2.txt: No such file or directory
      TEST_FILE.txt test.txt#{'     '}

      TEST_DIR:
      test_file_1.txt

      test:
      test_file_2.txt
    LS_RESULT
    assert_equal expected, `ruby #{@wd}/ls.rb test_nothing_file_1.txt test_nothing_file_2.txt test.txt TEST_FILE.txt TEST_DIR test`
  end

  def test_ls_directory_multi_byte_file_name
    FileUtils.cd("#{@wd}/test/test_directory_multi_byte_file_name")
    expected = "test_1_テスト.txt    test_3.txt           test_5.txt          \ntest_2.txt           test_4.txt           test_6.txt          \n"
    assert_equal expected, `ruby #{@wd}/ls.rb`
  end
end
