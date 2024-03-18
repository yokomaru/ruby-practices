#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1
NORMAL_BYTESIZE = 1
MARTI_BYTESIZE = 2

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

  display_files(arg_files, arg_files.size)
  puts if !arg_directories.empty? && !arg_files.empty?
  display_directories(arg_directories, args.size)
end

def display_files(files, files_count)
  return if files.empty?

  generated_files = generate_display_files(files, files_count)
  transpose_display_files(generated_files)
end

def display_directories(directories, args_count)
  return if directories.empty?

  directories_count = directories.size
  directories.each.with_index(1) do |directory, i|
    puts "#{directory.path}:" if args_count > 1

    directory_files = directory.each_child.filter do |file|
      !/^\./.match?(file)
    end
    directory_files_count = directory_files.size

    if directory_files_count >= 1
      generated_files = generate_display_files(directory_files, directory_files_count)
      transpose_display_files(generated_files)
    end

    puts if directories_count >= 1 && i < directories_count
  end
end

def generate_display_files(files, files_count)
  sorted_files = files.map { |file| file }.sort
  longest_filename_length = sorted_files.map(&:bytesize).max
  max_displayable_files_count_in_column = calculate_max_displayable_files_count_in_column(longest_filename_length, files_count)
  slice_display_files(sorted_files, max_displayable_files_count_in_column, longest_filename_length)
end

def calculate_max_displayable_files_count_in_column(longest_filename_length, files_count)
  terminal_width = `tput cols`.to_i # `tput cols` = 実行するターミナルの幅を取得
  max_displayable_files_count_in_a_row = terminal_width / (longest_filename_length + BUFFER_WIDTH)
  displayable_files_count_in_a_row = if max_displayable_files_count_in_a_row <= 0
                                       MIN_COLUMN
                                     elsif max_displayable_files_count_in_a_row < MAX_COLUMN
                                       max_displayable_files_count_in_a_row
                                     else
                                       MAX_COLUMN
                                     end
  (files_count.to_f / displayable_files_count_in_a_row).ceil
end

def slice_display_files(sorted_files, max_displayable_files_count, longest_filename_length)
  sorted_files.each_slice(max_displayable_files_count).map do |files|
    sliced_files = files.map { |file_name| file_name.ljust(calculate_align_left_width(file_name, longest_filename_length)) }
    sliced_files_count = sliced_files.size
    (max_displayable_files_count - sliced_files_count).times { sliced_files << '' } if sliced_files_count < max_displayable_files_count
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
