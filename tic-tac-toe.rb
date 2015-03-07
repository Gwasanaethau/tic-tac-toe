#========
# CELL
#========

class Cell
  attr_accessor :mark
  def initialize(mark = ' ')
    @mark = mark
  end
end

#========
# PLAYER
#========

class Player
  attr_reader :mark
  def initialize(settings_hash)
    @mark = settings_hash.fetch(:mark)
    @name = settings_hash.fetch(:name)
  end
end

#========
# BOARD
#========

class Board
  attr_accessor :grid
  def initialize(input = {})
    @grid = input.fetch(:grid, default_grid)
  end

  def mark(row, column, player_mark)
    @grid[row - 1][column - 1].mark = player_mark
  end

  def draw
    puts @grid[0][0].mark + '|' + @grid[0][1].mark + '|' + @grid[0][2].mark
    puts '–+–+–'
    puts @grid[1][0].mark + '|' + @grid[1][1].mark + '|' + @grid[1][2].mark
    puts '–+–+–'
    puts @grid[2][0].mark + '|' + @grid[2][1].mark + '|' + @grid[2][2].mark
  end

  private

  def default_grid
    Array.new(3) { Array.new(3) { Cell.new } }
  end
end

#========
# GAME
#========

class Game
  attr_reader :players
  def initialize(players, board)
    @players = players
    @board = board
    @current_player, @other_player = @players.shuffle
  end

  def play
    @board.draw
    # some sort of loop that gets input, passes to board, switches player, post board state
    # until win or stalemate.
  end

  private

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end
end

#========
# MAIN
#========

# Currently initialises a game with a blank board and default players (Player 1 and Player 2).
player1 = Player.new( { :name => 'Player 1', :mark => '×' } )
player2 = Player.new( { :name => 'Player 2', :mark => '∘' } )
game = Game.new( [player1, player2], Board.new )
game.play







