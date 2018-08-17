class Player
  attr_reader :color, :index, :sign, :goal
  attr_accessor :other

  def initialize(color, n)
    @color = color
    @index = n - 1
    @goal = BOARD[n == 1 ? 0 : -1][0]
    @sign = n == 1 ? +1 : -1
  end

  def inspect
    colorize("P#{index+1}", @color)
  end
  alias :to_s :inspect

  def negamax(state, max_depth)
    alpha = -Float::INFINITY
    best_action = nil

    state.sorted_successors(self).each do |action, s|
      value = -negamax_rec(s, -Float::INFINITY, -alpha, 1, max_depth, @other)
      if value > alpha
        alpha = value
        best_action = action
      end
    end

    best_action
  end

  def negamax_rec(state, alpha, beta, depth, max_depth, player)
    if depth == max_depth or state.finished?
      state.score(player)
    else
      state.sorted_successors(player).each do |a,s|
        value = -negamax_rec(s, -beta, -alpha, depth+1, max_depth, player.other)
        if value >= beta
          return value
        end
        if value > alpha
          alpha = value
        end
      end
      alpha
    end
  end

  def minimax(state, max_depth)
    value, best_action = max_value(state, -Float::INFINITY, Float::INFINITY, 0, max_depth)
    best_action
  end

  def max_value(state, alpha, beta, depth, max_depth)
    if depth == max_depth or state.finished?
      return state.score(self), nil
    end
    val = -Float::INFINITY
    action = nil
    state.sorted_successors(self).each do |a,s|
      v, _ = min_value(s, alpha, beta, depth + 1, max_depth)
      if v > val
        val = v
        action = a
        if v >= beta
          return v, a
        end
        if v > alpha
          alpha = v
        end
      end
    end
    [val, action]
  end

  def min_value(state, alpha, beta, depth, max_depth)
    if depth == max_depth or state.finished?
      return state.score(self), nil
    end
    val = Float::INFINITY
    action = nil
    state.sorted_successors(@other).each do |a,s|
      v, _ = max_value(s, alpha, beta, depth + 1, max_depth)
      if v < val
        val = v
        action = a
        if v <= alpha
          return v, a
        end
        if v < beta
          beta = v
        end
      end
    end
    [val, action]
  end
end

P1 = Player.new(:cyan, 1)
P2 = Player.new(:yellow, 2)
P1.other = P2
P2.other = P1
PLAYERS = [P1, P2]
