#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

def generate_calender
  params = ARGV.getopts('m:', 'y:')
  month = generate_month(params['m'])
  year = generate_year(params['y'])

  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)

  calender_dates = generate_calender_dates(first_date, last_date)

  carendar_display_data = generate_carendar_display_data(first_date, calender_dates)

  puts "#{first_date.month}月 #{first_date.year}".center(20)
  puts '日 月 火 水 木 金 土'

  carendar_display_data.each do |carendar_display_data|
    puts carendar_display_data.join(' ')
  end

  puts "\n"

end

def generate_month(param_month)
  param_month.to_i.between?(1, 12) ? param_month.to_i : Date.today.month
end

def generate_year(param_year)
  param_year.to_i.between?(1970, 2100) ? param_year.to_i : Date.today.year
end

def generate_calender_dates(first_date, last_date)
  (first_date..last_date).map do |date|
    if date == Date.today
      "\e[30m\e[47m#{date.day.to_s.rjust(2)}\e[0m"
    else
      date.day.to_s.rjust(2)
    end
  end
end

def generate_carendar_display_data(first_date, calender_dates)
  first_date.wday.times do
    calender_dates.unshift('　')
  end

  carendar_display_data = []
  calender_dates.each_slice(7) do |calender_date|
    carendar_display_data << calender_date
  end

  carendar_display_data
end

generate_calender
