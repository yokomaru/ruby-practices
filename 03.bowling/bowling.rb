#!/usr/bin/env ruby
# frozen_string_literal: true

def bowling
  scores = ARGV[0].split(",")
  shots = scores.each_with_object([]).with_index(1) do |(score, shot), index|
    if score == "X"
      shot << 10
      shot << 0
    else
      shot << score.to_i
    end
  end

  frames = []
  shots.each_slice(2) do |shot|
    frames << shot
  end

  puts frames
end

bowling
