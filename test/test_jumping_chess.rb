require 'test/unit'
require_relative '../lib/jumping_chess'

module TestJumpingChess
  def test_simple_move
    pos = [
      %w[00 01 11 02 12 22 03 13 23 44],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state0 = State.new(pos, nil)

    (1..5).each do |max_depth|
      action1 = P1.send(@strategy, state0, max_depth)
      state1 = state0.apply(P1, action1)
      assert_action(state1, action1, 44 => 33)
    end
  end

  def test_endgame1
    pos = [
      %w[00 01 11 02 12 22 03 23 33 44],
      %w[8g 7f 8f 6e 7e 8e 5d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state0 = State.new(pos, nil)

    (3..5).each do |max_depth|
      action1 = P1.send(@strategy, state0, max_depth)
      state1 = state0.apply(P1, action1)
      assert_action(state1, action1, 33 => 13)

      action2 = P1.send(@strategy, state1, max_depth)
      state2 = state1.apply(P1, action2)
      assert_action(state2, action2, 44 => 33)

      assert_same(P1, state2.winner)
    end
  end

  def test_endgame2
    pos = [
      %w[00 01 11 02 12 22 03 23 33 44],
      %w[8g 7f 8f 6e 7e 8e 6d 7d 8d 8c]
    ].map { |row| row.map { |name| COORDS_BY_NAME[name] } }
    state0 = State.new(pos, nil)

    [5].each do |max_depth|
      state = state0
      until state.finished?
        action = P1.send(@strategy, state, max_depth)
        state = state.apply(P1, action)
        # show(action, state)

        unless state.finished?
          action = P2.send(@strategy, state, max_depth)
          state = state.apply(P2, action)
          # show(action, state)
        end
      end

      assert_same(P1, state.winner)
    end
  end

  private

  def assert_action(state, actual, from_to)
    from_to = from_to.first.map { |c| COORDS_BY_NAME[c.to_s] }
    show(actual, state) if from_to != actual
    assert_equal(from_to, actual)
  end

  def show(action, state)
    puts action.join(' => ')
    state.show
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
