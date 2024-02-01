#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'

def bowling
  # 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
  p ARGV[0]
  score =  ARGV[0].split(",").map(&:to_i)
  shot = []
  10.times do
    shot << score.pop(2)
  end
  puts shot.sum(&:sum)
end

bowling

