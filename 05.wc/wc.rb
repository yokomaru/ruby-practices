#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DISPLAY_BUFFER_WIDTH = 8

# mainの作成
def main
  args = ARGV
  options = parse_options(args)
  strings = generate_strings_for_count(args)
  counts = []
  strings.map do |string|
    row = args.empty? ? string : File.read(string)
    count = []
    count << row.count("\n") if options[:l]
    count << row.split.size if options[:w]
    count << row.bytesize if options[:c]
    counts << count
    puts_count_string(count, args, string)
  rescue SystemCallError
    puts_error_message(string)
    counts << [0, 0, 0]
    next
  end
  count_total(counts, args)
end

def parse_options(args)
  options = args.getopts('wcl', symbolize_names: true)
  options = { w: true, c: true, l: true } if options.values.none?
  options
end

def generate_strings_for_count(args)
  # 引数がある場合は標準入力より引数の入力を優先させる
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
  puts "#{adjust_format_display_count(count)} #{file_name}"
end

def count_total(counts, args)
  totals = counts.transpose.map(&:sum)
  puts "#{adjust_format_display_count(totals)} total" if args.size > 1
end


def adjust_format_display_count(count)
  count.map { |c| c.to_s.rjust(DISPLAY_BUFFER_WIDTH) }.join
end

main if $PROGRAM_NAME == __FILE__
