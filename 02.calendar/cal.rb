#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

def generate_calender
  params = ARGV.getopts('m:', 'y:')

  month = params['m'].to_i.between?(1, 12) ? params['m'].to_i : Date.today.month
  year = params['y'].to_i.between?(1970, 2100) ? params['y'].to_i : Date.today.year

  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)

  calender_dates = (first_date..last_date).map { |date| date == Date.today ? "\e[30m\e[47m#{date.day.to_s.rjust(2)}\e[0m" : date.day.to_s.rjust(2) }
  first_date.wday.times { calender_dates.unshift('　') }

  puts "#{first_date.month}月 #{first_date.year}".center(20)
  puts '日 月 火 水 木 金 土'
  calender_dates.each_slice(7) { |calender_date| puts calender_date.join(' ') }
  puts "\n"
end

generate_calender
