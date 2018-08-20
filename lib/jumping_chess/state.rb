class State
  TRUFFLERUBY = RUBY_ENGINE == "truffleruby"
  MULTIPLE_JUMPS = true

  attr_reader :positions

  def initialize(positions, score = compute_score(positions), occupied = compute_occupied(positions))
    @positions = positions
    @score = score
    @occupied = occupied
  end

  def compute_occupied(positions)
    ALL_COORDS.map { |coord|
      positions[0].include?(coord) || positions[1].include?(coord)
    }
  end

  def apply(player, action)
    from, to = action
    i = @positions[player.index].index(from)
    copy_with_new_pos(player, i, from, to, false)
  end

  def sorted_successors(player, only_score)
    pawns = @positions[player.index]
    successors = []

    pawns.each_with_index { |pawn, i|
      pawn.direct_and_jump_neighbors.each { |neighbor, jump|
        if pawn?(neighbor)
          if jump and empty?(jump)
            successors << [[pawn, jump], copy_with_new_pos(player, i, pawn, jump, only_score)]
            jump(player, pawn, i, jump, [pawn, jump], successors, only_score) if MULTIPLE_JUMPS
          end
        else # empty
          successors << [[pawn, neighbor], copy_with_new_pos(player, i, pawn, neighbor, only_score)]
        end
      }
    }

    if only_score
      successors
    elsif TRUFFLERUBY
      # Faster on TruffleRuby, slower on CRuby
      successors.sort { |(a1,s1),(a2,s2)| s2.score(player) - s1.score(player) }
    else
      successors.sort_by { |a, s| -s.score(player) }
    end
  end

  def jump(player, pawn, i, start, visited, successors, only_score)
    start.jump_neighbors.each { |neighbor, jump|
      if !visited.include?(jump) and pawn?(neighbor) and empty?(jump)
        successors << [[pawn, jump], copy_with_new_pos(player, i, pawn, jump, only_score)]
        visited << jump
        jump(player, pawn, i, jump, visited, successors, only_score)
      end
    }
  end

  def pawn?(coord)
    @occupied[coord.index]
  end

  def empty?(coord)
    !pawn?(coord)
  end

  def valid_move?(player, move)
    sorted_successors(player, true).map(&:first).include?(move)
  end

  def copy_with_new_pos(player, i, old_pos, new_pos, only_score)
    score = @score + player.sign * (old_pos.distance2(player.goal) - new_pos.distance2(player.goal))
    if only_score
      State.new(nil, score, nil)
    else
      copy = @positions.dup
      (copy[player.index] = copy[player.index].dup)[i] = new_pos
      occupied = @occupied.dup
      occupied[old_pos.index] = false
      occupied[new_pos.index] = true
      State.new(copy, score, occupied)
    end
  end

  def score(player)
    @score * player.sign
  end

  def compute_score(positions)
    score_for(positions, 0, TOP) - score_for(positions, 1, BOTTOM)
  end

  def score_of(player)
    score_for(@positions, player.index, player.goal)
  end

  def score_for(positions, index, goal)
    -distance_left_for(positions, index, goal)
  end

  def distance_left_for(positions, index, goal)
    positions[index].sum { |c|
      c.distance2(goal)
    }
  end

  def finished?
    won?(0, TOP) or won?(1, BOTTOM)
  end

  def won?(index, goal)
    @positions[index].all? { |c| c.distance(goal) < CAMP }
  end
end

INITIAL_STATE = State.new([
  BOARD[-CAMP..-1].reverse.reduce(:+),
  BOARD[0...CAMP].reduce(:+),
])
