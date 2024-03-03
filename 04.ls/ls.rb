#!/usr/bin/env ruby

require 'optparse'
require 'debug'

COLUMN = 3
TERMINAL_WIDTH = IO::console_size[1]
MAX_COLUMN = 3
MIN_COLUMN = 1
BUFFER_WIDTH = 1

def main
  # 引数を受け取る
  args = ARGV
  p args

  directory_files = []
  if args.empty?
    sorted_directory_files = generate_directory_files(Dir.open('.'))
  elsif File.directory?(args[0])
    sorted_directory_files = generate_directory_files(Dir.open(args[0]))
  elsif File.file?(args[0])
    sorted_directory_files = sort_directory_files(args)
  else
    puts "ls: #{args[0]}: No such file or directory"
    return
  end

  return if sorted_directory_files.count.zero?

  max_file_name = fetch_max_file_name(sorted_directory_files)

  files_count = sorted_directory_files.count
  # ターミナルの幅を最大のファイルで割る数字を出す
  display_width = calculate_display_width(max_file_name)

  # 上の数字を1~3の数字に当てはめる
  slice_number = fetch_slice_number(display_width)

  # ファイルの総数とrowで割り算をしてcol算出する
  column_size = calculate_column_size(files_count, slice_number)

  display_files = fetch_display_files(sorted_directory_files, column_size, max_file_name)
  display_files.transpose.each {|files| puts files.join(" ")}
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
