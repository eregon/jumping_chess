require 'test/unit'
require_relative '../lib/jumping_chess'

module TestJumpingChess
  def test_simple_move
    pos = [
      %w[00 01 11 02 12 22 03 13 23 44],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state = State.new(pos)

    (1..@max_depth).each do |max_depth|
      game = Game.new(*players(max_depth), state, log: false)
      assert_action(game, game.play, 44 => 33)
      assert_same(game.player1, game.winner)
    end
  end

  def test_simple_jump
    pos = [
      %w[00 01 11 02 12 03 13 23 33 44],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state = State.new(pos)

    (1..@max_depth).each do |max_depth|
      game = Game.new(*players(max_depth), state, log: false)
      assert_action(game, game.play, 44 => 22)
      assert_same(game.player1, game.winner)
    end
  end

  def test_multi_jumps
    pos = [
      %w[11 23 14 15 36 57 67 77 89 8a],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state = State.new(pos)

    [1].each do |max_depth|
      game = Game.new(*players(max_depth), state, log: false)
      assert_action(game, game.play, "8a" => "00")
    end
  end

  def test_endgame1
    pos = [
      %w[00 01 11 02 12 22 03 23 33 44],
      %w[8g 7f 8f 6e 7e 8e 5d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state0 = State.new(pos)

    (3..@max_depth).each do |max_depth|
      game = Game.new(*players(max_depth), state0, log: false)

      assert_action(game, game.play, 33 => 13)
      game.play
      assert_action(game, game.play, 44 => 33)

      assert_same(game.player1, game.winner)
    end
  end

  def test_endgame2
    pos = [
      %w[00 01 11 02 12 22 03 23 33 44],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state0 = State.new(pos)

    (5..@max_depth).each do |max_depth|
      game = Game.new(*players(max_depth), state0, log: false)
      game.play until game.finished?
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
    @max_depth = 5
  end
end

class TestNegamax < Test::Unit::TestCase
  include TestJumpingChess
  def setup
    @strategy = "negamax"
    @max_depth = 5
  end
end

class TestGreedy < Test::Unit::TestCase
  include TestJumpingChess
  def setup
    @strategy = "greedy"
    @max_depth = 3
  end
end
