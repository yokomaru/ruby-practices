#!/usr/bin/env ruby
# frozen_string_literal: true

STRIKE_FIRST_SHOT_SCORE = 10
STRIKE_SECOND_SHOT_SCORE = 0
SPARE_SUM_SCORE = 10
LAST_FRAME = 9

def bowling
  scores = ARGV[0].split(',')
  shots = scores.each_with_object([]) do |score, shot|
    if score == 'X'
      shot << STRIKE_FIRST_SHOT_SCORE
      shot << STRIKE_SECOND_SHOT_SCORE
    else
      shot << score.to_i
    end
  end

  frames = []
  shots.each_slice(2) do |shot|
    frames << shot
  end

  point = 0
  frames.each_with_index do |frame, index|
    break if index > LAST_FRAME

    point += if frame[0] == STRIKE_FIRST_SHOT_SCORE
               if frames[index + 1][0] == STRIKE_FIRST_SHOT_SCORE
                 frame[0] + frames[index + 1][0] + frames[index + 2][0]
               else
                 frame[0] + frames[index + 1][0] + frames[index + 1][1]
               end
             elsif frame.sum == SPARE_SUM_SCORE
               frame.sum + frames[index + 1][0]
             else
               frame.sum
             end
  end
  puts point
end

bowling
