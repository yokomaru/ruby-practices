#!/usr/bin/env ruby
# frozen_string_literal: true

FRAME_TIMES = 10
STRIKE_SCORE = 10
SPARE_SCORE = 10

def bowling
  scores = ARGV[0].split(',')
  shots = scores.map { |score| score == 'X' ? STRIKE_SCORE : score.to_i }

  total_point = 0
  frame_head = 0

  FRAME_TIMES.times do
    total_point += if shots[frame_head] == STRIKE_SCORE || shots[frame_head] + shots[frame_head + 1] == SPARE_SCORE
                     shots[frame_head] + shots[frame_head + 1] + shots[frame_head + 2]
                   else
                     shots[frame_head] + shots[frame_head + 1]
                   end

    frame_head += shots[frame_head] == STRIKE_SCORE ? 1 : 2
  end

  puts total_point
end

bowling
