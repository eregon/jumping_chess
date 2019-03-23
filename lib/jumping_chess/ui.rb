class TextUI
  DIAMOND = true

  def initialize(game)
    @game = game
  end

  def show_turn
    puts "-" * 36
    puts "Turn #{@game.turn} #{@game.player} #{@game.action.join(' => ')}" if @game.action
  end

  def show_scores
    puts "Score: " + @game.players.map { |player|
      "#{player}=#{@game.state.score_of(player)}"
    }.join(" ")
  end

  def show_board
    if @game.action
      last_state = @game.state.undo(@game.player, @game.action)
      from, *path, to = last_state.path(@game.player, @game.action)
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
          owner = @game.players.find { |player|
            @game.state.positions[player.index].include?(cell)
          }
          owner&.color
        end
        colorize(cell, color)
      }.join('  ')
      puts if DIAMOND
    }
  end
end
