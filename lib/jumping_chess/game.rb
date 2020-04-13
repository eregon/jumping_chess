class Game
  attr_reader :turn, :player, :action, :players, :state, :ui
  attr_reader :player1, :player2

  def initialize(player1, player2, initial_state, first_player: player1,
                 log: !MRUBY, ui: WASM ? HTMLUI : TextUI)
    player1.other = player2
    player2.other = player1
    raise unless player1.sign == +1 and player2.sign == -1

    @players = (@player1, @player2 = player1, player2)
    @state = initial_state
    @turn = 0
    @player = first_player.other
    @save = Save.new if log
    @ui = ui.new(self)
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
      show
    }
  end

  def show
    @ui.show
  end

  def finished?
    @state.finished?
  end

  def winner
    @players.find { |player| @state.won?(player.index, player.goal) }
  end

  def run(turns = 1)
    while @turn < turns
      if finished?
        puts "Player #{winner.inspect} won!"
        break
      end

      play
      show
    end
  end
end
