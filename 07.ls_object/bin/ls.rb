#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative '../lib/ls_command'

if __FILE__ == $PROGRAM_NAME
  ls = LsCommand.new(".")
  puts ls.display
end
