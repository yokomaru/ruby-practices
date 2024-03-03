#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

TERMINAL_WIDTH = IO.console_size[1]
MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1

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
  return if check_directories_and_files_size(arg_directories, arg_files)

  display_files(arg_files, arg_files.count)
  puts if exist_directories_and_files?(arg_directories, arg_files)
  display_directories_files(arg_directories)
end

def display_files(arg_files, files_count)
  return if arg_files.empty?

  sorted_files = sort_directory_files(arg_files)
  max_file_name = fetch_max_file_name(sorted_files)
  display_width = calculate_display_width(max_file_name)
  slice_number = fetch_slice_number(display_width)
  column_size = calculate_column_size(files_count, slice_number)
  display_files = fetch_display_files(sorted_files, column_size, max_file_name)
  display_files.transpose.each { |files| puts files.join(' ') }
end

def display_directories_files(arg_directories)
  return if arg_directories.empty?

  arg_directories.each.with_index(1) do |directory, i|
    sorted_files = generate_directory_files(directory)
    max_file_name = fetch_max_file_name(sorted_files)
    files_count = sorted_files.count
    display_width = calculate_display_width(max_file_name)
    slice_number = fetch_slice_number(display_width)
    column_size = calculate_column_size(files_count, slice_number)
    display_directory_files = fetch_display_files(sorted_files, column_size, max_file_name)
    puts "#{directory.path}:" if arg_directories.size > 1
    display_directory_files.transpose.each { |files| puts files.join(' ') }
    puts if arg_directories.size > 1 && i < arg_directories.size
  end
end

def check_directories_and_files_size(arg_directories, arg_files)
  arg_directories.count.zero? && arg_files.count.zero?
end

def exist_directories_and_files?(arg_directories, arg_files)
  !arg_files.empty? && !arg_directories.empty?
end

def generate_directory_files(directory)
  directory_files = fetch_directory_files(directory)
  sort_directory_files(directory_files)
end

def fetch_directory_files(directory)
  directory_file_names_and_file_sizes = []
  directory.each_child do |file|
    directory_file_names_and_file_sizes << file unless /^\./.match?(file)
  end
  directory_file_names_and_file_sizes
end

def fetch_max_file_name(directory_files)
  directory_files.map(&:bytesize).max
end

def sort_directory_files(files)
  files.map { |file| file }.sort
end

def calculate_display_width(name)
  TERMINAL_WIDTH / (name + BUFFER_WIDTH)
end

def calculate_column_size(size, number)
  (size.to_f / number).ceil
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

def fetch_display_files(sorted_directory_files, column_size, max_file_name)
  sorted_directory_files.each_slice(column_size).map do |files|
    sliced_files = files.map { |file| file.ljust(calculate_align_left_size(file, max_file_name)) }
    (column_size - sliced_files.size).times { sliced_files << '' } if sliced_files.size < column_size
    sliced_files
  end
end

def calculate_align_left_size(string, size)
  output_width = string.each_char.map { |c| c.bytesize == 1 ? 1 : 2 }.reduce(0, &:+)
  padding_size = [0, size - output_width].max
  padding_size + string.size
end

main
