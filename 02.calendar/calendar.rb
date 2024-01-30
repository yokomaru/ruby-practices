#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'
require 'date'

params = ARGV.getopts("m:","y:")

month = params["m"].nil? || !params["m"].match?(/\A[0-9]+\z/) || !params["m"].to_i.between?(1, 12) ?  Date.today.month.to_i : params["m"].to_i
year = params["y"].nil? || !params["y"].match?(/\A[0-9]+\z/) || !params["y"].to_i.between?(1970, 2100) ? Date.today.year.to_i : params["y"].to_i

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

calender_days = (first_date..last_date).each_with_object([]) do |date, a|
  a << if date == Date.today
        date.day.to_s.length == 1 ? " \e[30m\e[47m#{date.day}\e[0m" : "\e[30m\e[47m#{date.day}\e[0m"
      else
        date.day.to_s.length == 1 ? " #{date.day}" : "#{date.day}"
      end
end

first_date.wday.times do
  calender_days.unshift("　")
end

carendar_display_datas = []
carendar_display_datas << ["　","　","#{first_date.month}月",first_date.year,"　","　","　"]
carendar_display_datas << ["日","月","火","水","木","金","土"]
calender_days.each_slice(7) do |calender_day|
  carendar_display_datas << calender_day
end

carendar_display_datas.each do |carendar_display_data|
  puts carendar_display_data.join(" ")
end
