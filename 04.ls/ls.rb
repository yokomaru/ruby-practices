#!/usr/bin/env ruby

require 'optparse'
require 'debug'

TERMINAL_WIDTH = IO::console_size[1]
MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1

def main
  # 引数を受け取る
  args = ARGV.sort
  directories = []
  files = []
  if args.empty?
    directories << Dir.open('.')
  else
    args.each do |arg|
      if File.directory?(arg)
        directories << Dir.open(arg)
      elsif File.file?(arg)
        files << arg
      else
        puts "ls: #{arg}: No such file or directory"
      end
    end
  end

  return if directories.count.zero? && files.count.zero?
  display_files(files, files.count) if !files.empty?
  puts if !files.empty? && !directories.empty?
  display_directories_files(directories) if !directories.empty?
end

def display_files(files, files_count)
  sorted_files = sort_directory_files(files)
  max_file_name = fetch_max_file_name(sorted_files)
  display_width = calculate_display_width(max_file_name)
  slice_number = fetch_slice_number(display_width)
  column_size = calculate_column_size(files_count, slice_number)
  display_files = fetch_display_files(sorted_files, column_size, max_file_name)
  display_files.transpose.each {|files| puts files.join(" ")}
end

def display_directories_files(directories)
  directories.each.with_index(1) do |directory, i|
    sorted_files = generate_directory_files(directory)
    max_file_name = fetch_max_file_name(sorted_files)
    files_count = sorted_files.count
    display_width = calculate_display_width(max_file_name)
    slice_number = fetch_slice_number(display_width)
    column_size = calculate_column_size(files_count, slice_number)
    display_directory_files = fetch_display_files(sorted_files, column_size, max_file_name)
    puts "#{directory.path}:" if directories.size > 1
    display_directory_files.transpose.each {|files| puts files.join(" ")}
    puts if directories.size > 1 && i < directories.size
  end
end

def generate_directory_files(directory)
  directory_files = fetch_directory_files(directory)
  sort_directory_files(directory_files)
end

def fetch_directory_files(directory)
  directory_file_names_and_file_sizes = []
  directory.each_child do |file|
    directory_file_names_and_file_sizes << file unless /^\./.match(file)
  end
  directory_file_names_and_file_sizes
end

def fetch_max_file_name(directory_files)
  directory_files.map { |file| file.bytesize }.max
end

def sort_directory_files(files)
  files.map { |file| file }.sort
end

def calculate_display_width(name)
  TERMINAL_WIDTH/(name + BUFFER_WIDTH)
end

def calculate_column_size(size, number)
  (size.to_f / number.to_f).ceil
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
    sliced_files = files.map{|file| file.ljust(calculate_align_left_size(file, max_file_name))}
    (column_size - sliced_files.size).times{sliced_files << ""} if sliced_files.size < column_size
    sliced_files
  end
end

def calculate_align_left_size(string, size)
  output_width = string.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
  padding_size = [0, size - output_width].max
  padding_size + string.size
end

main
