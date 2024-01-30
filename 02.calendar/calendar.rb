#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'
require 'date'

params = ARGV.getopts("m:","y:")

month = params["m"].to_i
year = params["y"].to_i

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

calender_array = (first_date..last_date).each_with_object([]) do |date, a|
  a << date
end

