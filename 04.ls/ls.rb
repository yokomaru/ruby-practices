#!/usr/bin/env ruby

require 'optparse'
require 'debug'

COLUMN = 3

def main
  args = ARGV

  tmp_directory_files = []
  directory_files = []
  if !args.empty?
    if File.directory?(args[0])
      directory = Dir.open(args[0])
      directory.each_child do |file|
        tmp_directory_files << {file_name: file, file_size: file.bytesize} unless /^\./.match(file)
      end
      directory_files = tmp_directory_files.map { |file| file[:file_name]}.sort
      max_file_name = tmp_directory_files.map { |file| file[:file_size] }.max
    elsif File.file?(args[0])
      args.each do |file|
        directory_files << file
      end
      max_file_name = directory_files.map { |file| file.size }.max
      p max_file_name
    else
      puts "ls: #{args[0]}: No such file or directory"
      return
    end
  else
    directory = Dir.open('.')
    directory.each_child do |file|
      tmp_directory_files << {file_name: file, file_size: file.bytesize} unless /^\./.match(file)
    end
    directory_files = tmp_directory_files.map { |file| file[:file_name]}.sort
    max_file_name = tmp_directory_files.map { |file| file[:file_size] }.max
  end

  file_size = directory_files.count
  terminal_width = IO::console_size[1]
  max_column = 3
  min_column = 1

  width = terminal_width/max_file_name

  #binding.break
  slice = if width <= 0
            min_column
          elsif width < max_column
            width
          elsif width >= max_column
            max_column
          end

  slice = (file_size.to_f / slice.to_f).ceil

  array = directory_files.each_slice(slice).map do |arr|
    new_arr = arr.map do |s|
       output_width = s.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
       padding_size = [0, max_file_name - output_width].max
       p "文字：#{s}"
       p "バイト数：#{s.bytesize}"
       p "padding_size: #{padding_size}"
       p "s.size: #{s.size}"
       s.ljust(padding_size + s.size)
    end
    if new_arr.size < slice
      (slice - new_arr.size).times do
        new_arr << ""
      end
    end
    new_arr
  end
  p array

  array.transpose.each do |a|
    puts a.join(" ")
  end
end

main
