class Player
  attr_reader :color, :index, :sign, :goal
  attr_accessor :other

  COLORS = { 1 => :cyan, 2 => :yellow }

  def initialize(n, strategy, max_depth)
    @color = COLORS[n] or raise
    @strategy = strategy
    @max_depth = max_depth

    @index = n - 1
    @goal = GOALS[@index]
    @sign = n == 1 ? +1 : -1
  end

  def to_s
    colorize("P#{index+1}", @color)
  end


  def inspect
    "#{self} (#{@strategy.capitalize} depth=#{@max_depth})"
  end

  def play(state)
    send(@strategy, state, @max_depth)
  end

  def human(state, max_depth)
    puts "Enter your move (e.g., 33 44)"
    begin
      print "> "
      STDOUT.flush
      command = (STDIN.gets || "exit").chomp.strip
      parts = command.split(" ")
      case parts.first
      when "exit"
        exit
      when "s", "suggest"
        parts << @suggest_strategy if parts.size == 1 and @suggest_strategy
        parts << @suggest_depth if parts.size == 2 and @suggest_depth
        raise "need strategy and max depth" unless parts.size == 3
        @max_depth = @suggest_depth = Integer(parts[2])
        @strategy = @suggest_strategy = parts[1]
        begin
          action = play(state)
        ensure
          @strategy = :human
        end
        puts "#{@suggest_strategy} #{@suggest_depth} would play #{action.join(' => ')}"
        raise ""
      else
        raise "need 2 coordinates" unless parts.size == 2
        move = parts.map { |coord| COORDS_BY_NAME[coord] }
        if state.valid_move?(self, move)
          move
        else
          raise "not a valid move"
        end
      end
    rescue => e
      puts e.message
      retry
    end
  end

  def greedy(state, max_depth)
    state.sorted_successors(self, 1 == max_depth).max_by { |a, s|
      greedy_rec(s, 1, max_depth)
    }.first
  end

  def greedy_rec(state, depth, max_depth)
    if depth == max_depth or state.finished?
      state.score(self)
    else
      state.sorted_successors(self, depth+1 == max_depth).max_by { |a, s|
        greedy_rec(s, depth + 1, max_depth)
      }.last.score(self)
    end
  end

  def negamax(state, max_depth)
    alpha = -Float::INFINITY
    best_action = nil

    state.sorted_successors(self, 1 == max_depth).each do |action, s|
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
      state.sorted_successors(player, depth+1 == max_depth).each do |a,s|
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
    state.sorted_successors(self, depth+1 == max_depth).each do |a,s|
      v, _ = min_value(s, alpha, beta, depth+1, max_depth)
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
    state.sorted_successors(@other, depth+1 == max_depth).each do |a,s|
      v, _ = max_value(s, alpha, beta, depth+1, max_depth)
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
