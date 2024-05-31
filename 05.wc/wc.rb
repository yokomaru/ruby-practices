#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DISPLAY_BUFFER_WIDTH = 8

# mainの作成
def main
  args = ARGV
  options = parse_options(args)
  strings_for_count = generate_count_strings(args)
  counts = []
  strings_for_count.map do |string|
    begin
      line = args.empty? ? string : File.read(string)
      count = []
      count << line.count("\n") if options[:l]
      count << line.split.size if options[:w]
      count << line.bytesize if options[:c]
      counts << count
      puts_count_string(count, args, string)
    rescue SystemCallError => e
      puts_error_message(string)
      counts << [0, 0, 0]
      next
    end
  end
  count_total(counts, args)
end

def parse_options(args)
  options = args.getopts('wcl', symbolize_names: true)
  options = {w: true, c: true, l: true} if options.values.none?
  options
end

def generate_count_strings(args)
  args.empty? ? [$stdin.readlines.join] : args
end

def puts_error_message(string)
  if File.directory?(string)
    puts "wc: #{string}: read: Is a directory"
  else
    puts "wc: #{string}: open: No such file or directory"
  end
end

def puts_count_string(count, args, string)
  file_name = string if !args.empty?
  puts "#{display_rjust(count)} #{file_name}"
end

def count_total(counts, args)
  totals = counts.transpose.map{|count| count.sum}
  puts "#{display_rjust(totals)} total" if args.size > 1
end

def display_rjust(array)
  array.map{|a| a.to_s.rjust(DISPLAY_BUFFER_WIDTH)}.join
end

main if $PROGRAM_NAME == __FILE__
