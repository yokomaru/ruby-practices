#!/usr/bin/env ruby
# frozen_string_literal: true

FRAME_TIMES = 10
STRIKE_SCORE = 10
SPARE_SCORE = 10
STRIKE_NEXT_FRAME = 1
SPARE_NEXT_FRAME = 2
NOMAL_NEXT_FRAME = 2

def bowling
  scores = ARGV[0].split(',')
  shots = scores.map { |score| score == 'X' ? STRIKE_SCORE : score.to_i }

  total_points = 0
  frame = 0

  FRAME_TIMES.times do
    if shots[frame] == STRIKE_SCORE
      total_points += shots[frame] + shots[frame + 1] + shots[frame + 2]
      frame += STRIKE_NEXT_FRAME
    elsif shots[frame] + shots[frame + 1] == SPARE_SCORE
      total_points += shots[frame] + shots[frame + 1] + shots[frame + 2]
      frame += SPARE_NEXT_FRAME
    else
      total_points += shots[frame] + shots[frame + 1]
      frame += NOMAL_NEXT_FRAME
    end
  end

  puts total_points
end

bowling
