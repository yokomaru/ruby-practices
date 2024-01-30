#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'
require 'date'

params = ARGV.getopts("m:","y:")

month = params["m"].nil? || !params["m"].match?(/[0-9]/) || !params["m"].to_i.between?(1, 12) ?  Date.today.month.to_i : params["m"].to_i
year = params["y"].nil? || !params["y"].match?(/[0-9]/) || !params["y"].to_i.between?(1970, 2100) ? Date.today.year.to_i : params["y"].to_i

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

calender_array = (first_date..last_date).each_with_object([]) do |date, a|
  a << if date.wday == 0
        date.day.to_s.length == 1 ? " \e[31m#{date.day}\e[0m" : "\e[31m#{date.day}\e[0m"
      elsif date.wday == 6
        date.day.to_s.length == 1 ? " \e[34m#{date.day}\e[0m" : "\e[34m#{date.day}\e[0m"
      else
        date.day.to_s.length == 1 ? " #{date.day}" : "#{date.day}"
      end
end

first_date.wday.times do
  calender_array.unshift("　")
end

carendar = []
carendar << ["　","　","#{first_date.month}月",first_date.year,"　","　","　"]
carendar << ["日","月","火","水","木","金","土"]
calender_array.each_slice(7) do |d|
  carendar << d
end

carendar.each do |c|
  puts c.join(" ")
end
