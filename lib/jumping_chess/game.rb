class Game
  DIAMOND = true

  attr_reader :turn, :player, :action, :state
  attr_reader :player1, :player2

  def initialize(player1, player2, initial_state, first_player: player1, log: true)
    player1.other = player2
    player2.other = player1
    raise unless player1.sign == +1 and player2.sign == -1

    @players = (@player1, @player2 = player1, player2)
    @state = initial_state
    @turn = 0
    @player = first_player.other
    @save = Save.new if log
  end

  def play(player = @player.other)
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
      show(scores: true)
    }
  end

  def show(scores: false)
    puts "-" * 36
    puts "Turn #{@turn} #{@player} #{@action.join(' => ')}" if @action
    if scores
      puts "Score: " + @players.map { |player| "#{player}=#{@state.score_of(player)}" }.join(" ")
    end
    show_board
  end

  def show_board
    if @action
      last_state = state.undo(@player, @action)
      from, *path, to = last_state.path(@player, @action)
    end
    puts
    BOARD.each_with_index { |row, y|
      margin = '  ' * (MIDDLE_Y-y).abs
      puts margin + row.map { |cell|
        color = case cell
        when from
          :bright_red
        when to
          :bright_green
        when *path
          :bright_blue
        else
          owner = @players.find { |player|
            @state.positions[player.index].include?(cell)
          }
          owner&.color
        end
        colorize(cell, color)
      }.join('  ')
      puts if DIAMOND
    }
  end

  def finished?
    @state.finished?
  end

  def winner
    @players.find { |player| @state.won?(player.index, player.goal) }
  end
end
