#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1
NORMAL_BYTESIZE = 1
MARTI_BYTESIZE = 2

def main
  option_params = OptionParser.new

  options = {}
  option_params.on('-a') { |param| options[:a] = param }
  option_params.on('-r') { |param| options[:r] = param }

  option_params.parse!(ARGV)

  args = ARGV
  arg_directories = []
  arg_files = []
  arg_directories << Dir.open('.') if args.empty?

  args.each do |arg|
    next arg_directories << Dir.open(arg) if File.directory?(arg)
    next arg_files << arg if File.file?(arg)

    puts "ls: #{arg}: No such file or directory"
  end

  display_files(arg_files)
  puts if !arg_directories.empty? && !arg_files.empty?
  display_directories(arg_directories, args.size, options)
end

def display_files(files)
  return if files.empty?

  generated_files = generate_display_files(files)
  transpose_display_files(generated_files)
end

def display_directories(directories, arg_counts, options)
  return if directories.empty?

  directories.each.with_index(1) do |directory, i|
    puts "#{directory.path}:" if arg_counts > 1
    directory_files = directory.entries.filter { |file| options[:a] ? file : !/^\./.match?(file) }
    next if directory_files.empty?

    generated_files = generate_display_files(directory_files)
    transpose_display_files(generated_files)
    puts if i < directories.size
  end
end

def generate_display_files(files)
  longest_filename_length = files.map(&:bytesize).max
  file_counts_in_column = calculate_file_counts_in_column(longest_filename_length, files.size)
  slice_display_files(files, file_counts_in_column, longest_filename_length)
end

def calculate_file_counts_in_column(filename_length, file_counts)
  terminal_width = `tput cols`.to_i # `tput cols` = 実行するターミナルの幅を取得
  max_file_counts_in_row = terminal_width / (filename_length + BUFFER_WIDTH)
  min_file_counts_in_row = [max_file_counts_in_row, MIN_COLUMN].max
  file_counts_in_row = [min_file_counts_in_row, MAX_COLUMN].min
  (file_counts.to_f / file_counts_in_row).ceil
end

def slice_display_files(sorted_files, file_counts_in_column, longest_filename_length)
  sorted_files.each_slice(file_counts_in_column).map do |files|
    sliced_files = files.map { |file_name| file_name.ljust(calculate_align_left_width(file_name, longest_filename_length)) }
    sliced_file_counts = sliced_files.size
    (file_counts_in_column - sliced_file_counts).times { sliced_files << '' } if sliced_file_counts < file_counts_in_column
    sliced_files
  end
end

def calculate_align_left_width(file_name, longest_filename_length)
  adjusted_byte_number = file_name.each_char
                                  .map { |char| char.bytesize == NORMAL_BYTESIZE ? NORMAL_BYTESIZE : MARTI_BYTESIZE }
                                  .sum
  padding_size = [0, longest_filename_length - adjusted_byte_number].max
  padding_size + file_name.size
end

def transpose_display_files(display_files)
  display_files.transpose.each { |files| puts files.join(' ').strip }
end

main
