#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative '../lib/ls_command'

if __FILE__ == $PROGRAM_NAME
  opt = OptionParser.new

  params = { dot_match: false }
  opt.on('-a') { |v| params[:dot_match] = v }
  opt.on('-r') { |v| params[:reverse] = v }
  opt.on('-l') { |v| params[:long_format] = v }
  opt.parse!(ARGV)

  ls = LsCommand.new('.', **params)
  ls.build_files
  puts ls.display
end
