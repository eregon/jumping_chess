require 'test/unit'
require_relative '../lib/jumping_chess'

module TestJumpingChess
  def test_simple_move
    pos = [
      %w[00 01 11 02 12 22 03 13 23 44],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state = State.new(pos, nil)

    (1..5).each do |max_depth|
      game = Game.new(*players(max_depth), state, log: false)
      assert_action(game, game.turn, 44 => 33)
      assert_same(game.player1, game.winner)
    end
  end

  def test_endgame1
    pos = [
      %w[00 01 11 02 12 22 03 23 33 44],
      %w[8g 7f 8f 6e 7e 8e 5d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state0 = State.new(pos, nil)

    (3..5).each do |max_depth|
      game = Game.new(*players(max_depth), state0, log: false)

      assert_action(game, game.turn, 33 => 13)
      game.turn
      assert_action(game, game.turn, 44 => 33)

      assert_same(game.player1, game.winner)
    end
  end

  def test_endgame2
    pos = [
      %w[00 01 11 02 12 22 03 23 33 44],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state0 = State.new(pos, nil)

    [5].each do |max_depth|
      game = Game.new(*players(max_depth), state0, log: false)
      game.turn until game.finished?
      assert_same(game.player1, game.winner)
    end
  end

  private

  def players(max_depth)
    [
      Player.new(1, @strategy, max_depth),
      Player.new(2, @strategy, max_depth)
    ]
  end

  def assert_action(game, actual, from_to)
    from_to = from_to.first.map { |c| COORDS_BY_NAME[c.to_s] }
    game.show if from_to != actual
    assert_equal(from_to, actual)
  end
end

class TestMinimax < Test::Unit::TestCase
  include TestJumpingChess
  def setup
    @strategy = "minimax"
  end
end

class TestNegamax < Test::Unit::TestCase
  include TestJumpingChess
  def setup
    @strategy = "negamax"
  end
end
