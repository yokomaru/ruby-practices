require_relative 'frame'

require 'minitest/autorun'
require 'minitest/pride'
require_relative 'bowling'

class Game
  def initialize(shots)
    @shots = shots
  end
  # FRAMEに移動する
  FRAME_TIMES = 10
  STRIKE_SCORE = 10
  SPARE_SCORE = 10

  # 引数で渡すようにする
  # FRAMEに移動する
  def calc_scores
    scores = @shots.split(',').map { |score| score == 'X' ? STRIKE_SCORE : score.to_i }
    total_point = 0
    frame_head = 0
    FRAME_TIMES.times do
      # puts scores[frame_head]
      # puts scores[frame_head + 1]
      # puts scores[frame_head] + scores[frame_head + 1]
      # puts scores[frame_head] + scores[frame_head + 1] == SPARE_SCORE
      # FRAMEに移動する
      total_point += if scores[frame_head] == STRIKE_SCORE || scores[frame_head] + scores[frame_head + 1] == SPARE_SCORE
                       frame = Frame.new(scores[frame_head], scores[frame_head + 1], scores[frame_head + 2])
                       #  puts 'スペアかストライク'
                       #  puts scores[frame_head + 2]
                       #  puts frame.score
                       frame.score
                     else
                       frame = Frame.new(scores[frame_head], scores[frame_head + 1])
                       frame.score
                     end

      frame_head += scores[frame_head] == STRIKE_SCORE ? 1 : 2
    end
    total_point
  end
end

# marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
# game = Game.new(marks)
# assert_equal 164, game.calc_scores

# # テストを追加

class BowlingTest < Minitest::Test
  def test_score1
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    game = Game.new(marks)
    assert_equal 139, game.calc_scores
  end

  def test_score2
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    game = Game.new(marks)
    assert_equal 164, game.calc_scores
  end

  def test_score3
    marks = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    game = Game.new(marks)
    assert_equal 107, game.calc_scores
  end

  def test_score4
    marks = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    game = Game.new(marks)
    assert_equal 134, game.calc_scores
  end

  def test_perfect_game
    marks = 'X,X,X,X,X,X,X,X,X,X,X,X'
    game = Game.new(marks)
    assert_equal 300, game.calc_scores
  end
end
