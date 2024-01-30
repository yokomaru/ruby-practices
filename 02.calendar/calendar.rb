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

a = calender_array.map do |d|
  if d.wday == 0
    d.day.to_s.length == 1 ? " \e[31m#{d.day}\e[0m" : "\e[31m#{d.day}\e[0m"
  elsif d.wday == 6
    d.day.to_s.length == 1 ? " \e[34m#{d.day}\e[0m" : "\e[34m#{d.day}\e[0m"
  else
    d.day.to_s.length == 1 ? " #{d.day}" : "#{d.day}"
  end
end

first_date.wday.times do
  a.unshift("　")
end
