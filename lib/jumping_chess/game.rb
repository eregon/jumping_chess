class Game
  attr_reader :player, :state, :action
  attr_reader :player1, :player2

  def initialize(player1, player2, initial_state, first_player = player1)
    player1.other = player2
    player2.other = player1

    @players = (@player1, @player2 = player1, player2)
    initial_state.compute_score(@players)

    @state = initial_state
    @turn = 0
    @player = first_player.other
  end

  def turn
    play(@player.other)
  end

  def play(player)
    @player = player
    @turn += 1
    @action = @player.play(@state)
    @state = @state.apply(@player, @action)
    @action
  end

  def show(scores: false)
    puts "-" * 36
    puts "Turn #{@turn} #{@player} #{@action.join(' => ')}"
    if scores
      puts "Score: " + @players.map { |player| "#{player}=#{@state.score_for(player)}" }.join(" ")
    end
    show_board
  end

  def show_board
    puts
    BOARD.each_with_index { |row, y|
      margin = '  ' * (MIDDLE_Y-y).abs
      puts margin + row.map { |cell|
        owner = @players.find { |player|
          @state.positions[player.index].include?(cell)
        }
        colorize(cell, owner&.color)
      }.join('  ')
    }
  end

  def finished?
    @state.finished?
  end

  def winner
    @players.find { |player| @state.won?(player.index, player.goal) }
  end
end
