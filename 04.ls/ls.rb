#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1
NORMAL_BYTE_SIZE = 1
MARTI_BYTE_SIZE = 2

def main
  args = ARGV.sort
  arg_directories = []
  arg_files = []
  arg_directories << Dir.open('.') if args.empty?

  args.each do |arg|
    next arg_directories << Dir.open(arg) if File.directory?(arg)
    next arg_files << arg if File.file?(arg)

    puts "ls: #{arg}: No such file or directory"
  end

  display_files(arg_files, arg_files.count)
  puts if exist_directories_and_files?(arg_directories, arg_files)
  display_directories(arg_directories, args.size)
end

def exist_directories_and_files?(directories, files)
  !directories.empty? && !files.empty?
end

def display_files(files, files_count)
  return if files.empty?

  generated_files = generate_display_files(files, files_count)
  transpose_display_files(generated_files)
end

def display_directories(directories, args_size)
  return if directories.empty?

  directories_count = directories.size
  directories.each.with_index(1) do |directory, i|
    puts "#{directory.path}:" if args_size > 1

    directory_files = []
    directory.each_child do |file|
      directory_files << file unless /^\./.match?(file)
    end
    files_count_in_directory = directory_files.count

    if files_count_in_directory >= 1
      generated_files = generate_display_files(directory_files, files_count_in_directory)
      transpose_display_files(generated_files)
    end

    puts if directories_count >= 1 && i < directories_count
  end
end

def generate_display_files(files, files_count)
  sorted_files = files.map { |file| file }.sort
  longest_filename_size = sorted_files.map(&:bytesize).max
  column_size = calculate_column_size(longest_filename_size, files_count)
  slice_column_size_display_files(sorted_files, column_size, longest_filename_size)
end

def calculate_column_size(longest_filename_size, files_count)
  # IO.console_size[1] = 実行するターミナルの幅を取得
  display_width = IO.console_size[1] / (longest_filename_size + BUFFER_WIDTH)
  slice_number = fetch_slice_number(display_width)
  (files_count.to_f / slice_number).ceil
end

def fetch_slice_number(width)
  if width <= 0
    MIN_COLUMN
  elsif width < MAX_COLUMN
    width
  elsif width >= MAX_COLUMN
    MAX_COLUMN
  end
end

def slice_column_size_display_files(sorted_files, column_size, longest_filename_size)
  sorted_files.each_slice(column_size).map do |files|
    sliced_files = files.map { |file| file.ljust(calculate_align_left_size(file, longest_filename_size)) }
    (column_size - sliced_files.size).times { sliced_files << '' } if sliced_files.size < column_size
    sliced_files
  end
end

def calculate_align_left_size(file_name, longest_filename_size)
  adjusted_byte_number = file_name.each_char.map { |c| c.bytesize == NORMAL_BYTE_SIZE ? NORMAL_BYTE_SIZE : MARTI_BYTE_SIZE }.reduce(0, &:+)
  padding_size = [0, longest_filename_size - adjusted_byte_number].max
  padding_size + file_name.size
end

def transpose_display_files(display_files)
  display_files.transpose.each { |files| puts files.join(' ') }
end

main
