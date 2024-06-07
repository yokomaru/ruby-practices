#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DISPLAY_BUFFER_WIDTH = 8

# mainの作成
def main
  arguments = ARGV
  options = parse_options(arguments)
  if arguments.empty?
    wc_standard_input(options)
  else
    wc_input_files(arguments, options)
  end
end

def parse_options(args)
  options = args.getopts('wcl', symbolize_names: true)
  options = { w: true, c: true, l: true } if options.values.none?
  options
end

def wc_standard_input(options)
  input_source = $stdin.readlines.join
  count = count_input_text(input_source, options)
  puts adjust_format_display_count(count)
end

def wc_input_files(arguments, options)
  counts = arguments.map do |argument|
    file_content = generate_file_content(argument)
    if file_content[:type] == 'file'
      count = count_input_text(file_content[:text], options)
      puts "#{adjust_format_display_count(count)} #{file_content[:name]}"
      count
    else
      puts file_content[:error_message]
    end
  end
  puts_total_count(counts) if arguments.size > 1
end

def count_input_text(input, options)
  count = []
  count << input.count("\n") if options[:l]
  count << input.split.size if options[:w]
  count << input.bytesize if options[:c]
  count
end

def generate_file_content(argument)
  if File.file?(argument)
    { type: 'file', text: File.read(argument), name: argument }
  elsif File.directory?(argument)
    { type: 'direcroty', error_message: "wc: #{argument}: read: Is a directory" }
  else
    { type: 'none', error_message: "wc: #{argument}: open: No such file or directory" }
  end
end

def puts_total_count(counts)
  total_count = counts.compact.transpose.map(&:sum)
  puts "#{adjust_format_display_count(total_count)} total"
end

def adjust_format_display_count(count)
  count.map { |c| c.to_s.rjust(DISPLAY_BUFFER_WIDTH) }.join
end

main if $PROGRAM_NAME == __FILE__
