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

  carendar_display_data.each do |carendar_display_data|
    puts carendar_display_data.join(' ')
  end
end

def generate_month(param_month)
  param_month.nil? || !param_month.match?(/\A[0-9]+\z/) || !param_month.to_i.between?(1, 12) ? Date.today.month.to_i : param_month.to_i
end

def generate_year(param_year)
  param_year.nil? || !param_year.match?(/\A[0-9]+\z/) || !param_year.to_i.between?(1970, 2100) ? Date.today.year.to_i : param_year.to_i
end

def generate_calender_dates(first_date, last_date)
  (first_date..last_date).each_with_object([]) do |date, a|
    a << if date == Date.today
           date.day.to_s.length == 1 ? " \e[30m\e[47m#{date.day}\e[0m" : "\e[30m\e[47m#{date.day}\e[0m"
         else
           date.day.to_s.length == 1 ? " #{date.day}" : date.day.to_s
         end
  end
end

def generate_carendar_display_data(first_date, calender_dates)
  first_date.wday.times do
    calender_dates.unshift('　')
  end

  carendar_display_data = []
  carendar_display_data << ['　', '　', "#{first_date.month}月", first_date.year, '　', '　', '　']
  carendar_display_data << %w[日 月 火 水 木 金 土]
  calender_dates.each_slice(7) do |calender_date|
    carendar_display_data << calender_date
  end

  carendar_display_data << []

  carendar_display_data
end

generate_calender
