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

  point = 0
  frames.each_with_index do |frame, index|
    # 10フレーム目以降は計算しない
    break if index > 9
    # ストライクだった場合
    if frame[0] == 10
      # 次もストライクだった場合
      if frames[index + 1][0] == 10
        # 次とその次のフレームの１投目を合計した値を合算する
        point += frame[0] + frames[index + 1][0] + frames[index + 2][0]
      # 次がストライクじゃなかった場合は次のフレームの１投目と２投目を合算する
      else
        point += frame[0] + frames[index + 1][0] + frames[index + 1][1]
      end
    # スペアだった場合
    elsif frame.sum == 10
      # 次のフレームの１投目を合算する
      point += frame.sum + frames[index + 1][0]
    else
      # 現在のフレームの合計を合算する
      point += frame.sum
    end
  end
  puts point
end

bowling
