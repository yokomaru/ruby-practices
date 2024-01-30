#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'

params = ARGV.getopts('my:')
puts params
