#!/usr/bin/env ruby

require 'optparse'
require 'debug'

COLUMN = 3

def main
  directory = ARGV.empty? ? Dir.open('.') : Dir.open(ARGV[0])
  directory_files = []
  directory.each_child do |file|
    directory_files << file.ljust(21) unless /^\./.match(file)
  end

  directory_file_size = directory_files.count
  row = directory_file_size % COLUMN == 0 ? directory_file_size / COLUMN :  directory_file_size / COLUMN + 1
  sorted_directory_files = directory_files.sort

  arr = Array.new(COLUMN) { Array.new(row, nil) }
  arr_int = 0
  arr_arr_int = 0
  sorted_directory_files.each.with_index(1) do |file, i|
    arr[arr_int][arr_arr_int] = file
    arr_arr_int += 1
    if i % row == 0
      arr_int += 1
      arr_arr_int = 0
    end
  end
  map_array = sorted_directory_files.each_slice(3).map {|arr| arr}

  arr.transpose.each do |a|
    puts a.join(" ")
  end

end

main
