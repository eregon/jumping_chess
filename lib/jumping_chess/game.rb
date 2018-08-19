class Game
  attr_reader :player, :state, :action
  attr_reader :player1, :player2

  def initialize(player1, player2, initial_state, first_player: player1, log: true)
    player1.other = player2
    player2.other = player1

    @players = (@player1, @player2 = player1, player2)
    initial_state.compute_score(@players)

    @state = initial_state
    @turn = 0
    @player = first_player.other
    @save = Save.new if log
  end

  def turn
    play(@player.other)
  end

  def play(player)
    action = player.play(@state)
    apply_move(player, action)
    action
  end

  def apply_move(player, action)
    @turn += 1
    @player = player
    @action = action

    @state = @state.apply(@player, @action)

    @save.record @action if @save
  end

  def load(file)
    Save.load(file) { |action|
      apply_move(@player.other, action)
    }
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

  def current_turn
    @turn
  end

  def finished?
    @state.finished?
  end

  def winner
    @players.find { |player| @state.won?(player.index, player.goal) }
  end
end
