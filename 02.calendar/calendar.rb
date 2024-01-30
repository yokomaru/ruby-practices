#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'

params = ARGV.getopts("m:","y:")
puts params
