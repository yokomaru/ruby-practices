#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DISPLAY_BUFFER_WIDTH = 8

def main
  arguments = ARGV
  options = parse_options(arguments)
  argument_empty = arguments.empty?
  inputs = argument_empty ? [$stdin.readlines.join] : arguments
  puts wc(inputs, options, argument_empty)
end

def parse_options(arguments)
  options = arguments.getopts('wcl', symbolize_names: true)
  options.values.none? ? { w: true, c: true, l: true } : options
end

def wc(inputs, options, argument_empty)
  input_counts = inputs.map { |input| build_input_count(input, argument_empty, options) }
  outputs = input_counts.map do |input_count|
    build_output(input_count[:error_message], input_count[:count], input_count[:filename])
  end
  total_counts = input_counts.map { |input_count| input_count[:count] }.transpose.map(&:sum)
  outputs << format_count(total_counts, 'total') if input_counts.size > 1
  outputs
end


def build_input_count(input, argument_empty, options)
  if argument_empty
    { filename: '', count: build_count(input, options) }
  elsif File.file?(input)
    { filename: input, count: build_count(File.read(input), options) }
  elsif File.directory?(input)
    { error_message: "wc: #{input}: read: Is a directory", count: build_count('', options) } # オプションに応じた0の配列を受け取る
  else
    { error_message: "wc: #{input}: open: No such file or directory", count: build_count('', options) } # オプションに応じた0の配列を受け取る
  end
end

def build_count(input, options)
  count = []
  count << input.count("\n") if options[:l]
  count << input.split.size if options[:w]
  count << input.bytesize if options[:c]
  count
end

def build_output(error_message, count, name)
  error_message.nil? ? format_count(count, name) : error_message
end

def format_count(count, name)
  "#{count.map { |c| c.to_s.rjust(DISPLAY_BUFFER_WIDTH) }.join} #{name}"
end

main if $PROGRAM_NAME == __FILE__
