class UI
  def initialize(game)
    @game = game
  end
end

class TextUI < UI
  DIAMOND = true

  def show
    show_turn
    show_scores
    show_board
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
      puts margin + row.map { |coord|
        color = case coord
        when from
          :bright_red
        when to
          :bright_green
        when *path
          :bright_blue
        else
          owner = @game.players.find { |player|
            @game.state.positions[player.index].include?(coord)
          }
          owner&.color
        end
        colorize(coord, color)
      }.join('  ')
      puts if DIAMOND
    }
  end
end

class HTMLUI < UI
  WIDTH = 400
  HEIGHT = 350
  MARGIN = 10
  DV = 20
  R = 7

  def show
    out = ""

    header = "Turn #{@game.turn} #{@game.player}"
    header << " #{@game.action.join(' => ')}" if @game.action
    out << "<p>#{header}</p>"
    out << %Q{<svg height="#{HEIGHT}" width="#{WIDTH}">}

    BOARD.each_with_index { |row, y|
      row.each_with_index { |coord, x|
        owner = @game.players.find { |player|
          @game.state.positions[player.index].include?(coord)
        }
        color = owner&.color
        color = COLOR_MAPPINGS[color] || color

        out << pawn(coord, color)
      }
    }

    if @game.action
      last_state = @game.state.undo(@game.player, @game.action)
      path = last_state.path(@game.player, @game.action)
      out << polyline(path, :black)
    end

    DOM.createElement('table')

    out << "</svg>"
    out
  end

  def tx(coord)
    MARGIN + coord.dx * DV
  end

  def ty(coord)
    MARGIN + coord.dy * DV
  end

  def pawn(coord, color)
    xml('circle', cx: tx(coord), cy: ty(coord), r: R, :'stroke-width' => 0, stroke: color, fill: color)
  end

  def polyline(path, color)
    xml('polyline', points: path.map { |c| "#{tx(c)},#{ty(c)}" }.join(' '),
                    style: "stroke: #{color}; stroke-width: 2; fill: none")
  end

  def xml(tag, options = {})
    options = options.map { |k,v| "#{k}=#{v.to_s.inspect}" }.join(' ')
    "<#{tag} #{options}>#{yield if block_given?}</#{tag}>"
  end
end
