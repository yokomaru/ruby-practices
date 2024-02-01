#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'

def bowling
  score = ARGV[0].split(",")
  frame = score.each_with_object([]) do |s, a|
    if s == "X"
      a << 10
      a << 0
    else
      a << s.to_i
    end
  end
  p frame
  p frame.size
  shot = []
  10.times do
    shot << frame.pop(2)
  end
  p shot.sum(&:sum)
end

bowling
