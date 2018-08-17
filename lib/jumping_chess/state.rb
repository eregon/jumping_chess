class State
  TRUFFLERUBY = RUBY_ENGINE == "truffleruby"

  attr_reader :positions

  def initialize(positions, score)
    @positions = positions
    @score = score || compute_score
  end

  def apply(player, action)
    from, to = action
    i = @positions[player.index].index(from)
    copy_with_new_pos(player, i, from, to)
  end

  def sorted_successors(player)
    pawns = @positions[player.index]
    successors = []

    pawns.each_with_index { |pawn, i|
      pawn.direct_and_jump_neighbors.each { |neighbor, jump|
        if pawn?(neighbor)
          if jump and empty?(jump)
            successors << [[pawn, jump], copy_with_new_pos(player, i, pawn, jump)]
          end
        else # empty
          successors << [[pawn, neighbor], copy_with_new_pos(player, i, pawn, neighbor)]
        end
      }
    }

    if TRUFFLERUBY
      # Faster on TruffleRuby, slower on CRuby
      successors.sort { |(a1,s1),(a2,s2)| s2.score(player) - s1.score(player) }
    else
      successors.sort_by { |a, s| -s.score(player) }
    end
  end

  def pawn?(coord)
    @positions[0].include?(coord) || @positions[1].include?(coord)
  end

  def empty?(coord)
    !pawn?(coord)
  end

  def copy_with_new_pos(player, i, old_pos, new_pos)
    score = @score + player.sign * (old_pos.distance(player.goal) - new_pos.distance(player.goal))
    copy = @positions.dup
    (copy[player.index] = copy[player.index].dup)[i] = new_pos
    State.new(copy, score)
  end

  def score(player)
    @score * player.sign
  end

  def compute_score
    P1.sign * score_for(P1) + P2.sign * score_for(P2)
  end

  def score_for(player)
    -distance_left_for(player)
  end

  def distance_left_for(player)
    @positions[player.index].sum { |c|
      c.distance(player.goal)
    }
  end

  def finished?
    won?(P1) or won?(P2)
  end

  def won?(player)
    @positions[player.index].all? { |c| c.distance(player.goal) < CAMP }
  end

  def winner
    PLAYERS.find { |player| won?(player) }
  end

  def show
    puts
    BOARD.each_with_index { |row, y|
      margin = '  ' * (MIDDLE_Y-y).abs
      puts margin + row.map { |cell|
        color = case
        when @positions[P1.index].include?(cell)
          P1.color
        when @positions[P2.index].include?(cell)
          P2.color
        end
        colorize(cell, color)
      }.join('  ')
    }
  end
end

INITIAL_STATE = State.new([
  BOARD[-CAMP..-1].reverse.reduce(:+),
  BOARD[0...CAMP].reduce(:+),
], nil)
