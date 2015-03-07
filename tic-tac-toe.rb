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
  attr_reader :name
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
    @grid[row][column].mark = player_mark
  end

  def draw_board
    puts @grid[0][0].mark + '|' + @grid[0][1].mark + '|' + @grid[0][2].mark
    puts '–+–+–'
    puts @grid[1][0].mark + '|' + @grid[1][1].mark + '|' + @grid[1][2].mark
    puts '–+–+–'
    puts @grid[2][0].mark + '|' + @grid[2][1].mark + '|' + @grid[2][2].mark
  end

  def won?
    # Yeah, this is horrible, but it works, so it’s staying for the moment! S;-Þ
    # It is essentially checking each row, column and diagonal for winning moves
    # and making sure they are not winning moves of empty cells!
    @grid[0][0].mark != ' ' && @grid[0][0].mark == @grid[0][1].mark && @grid[0][1].mark == @grid[0][2].mark ||
    @grid[1][0].mark != ' ' && @grid[1][0].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[1][2].mark ||
    @grid[2][0].mark != ' ' && @grid[2][0].mark == @grid[2][1].mark && @grid[2][1].mark == @grid[2][2].mark ||
    @grid[0][0].mark != ' ' && @grid[0][0].mark == @grid[1][0].mark && @grid[1][0].mark == @grid[2][0].mark ||
    @grid[0][1].mark != ' ' && @grid[0][1].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[2][1].mark ||
    @grid[0][2].mark != ' ' && @grid[0][2].mark == @grid[1][2].mark && @grid[1][2].mark == @grid[2][2].mark ||
    @grid[0][0].mark != ' ' && @grid[0][0].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[2][2].mark ||
    @grid[0][2].mark != ' ' && @grid[0][2].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[2][0].mark
  end

  def draw?
    @grid.all? do |row|
      row.all? do |cell|
        cell.mark != ' '
      end
    end
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
    @board.draw_board

    until @board.won? || @board.draw?
      puts "#{@current_player.name}: you’re up!"
      puts "Select a slot to place your #{@current_player.mark} in."

      slot = gets.chomp.to_i - 1 #FIXME: Assumes input is in correct format for the moment…
      puts

      row = slot / 3
      column = slot % 3
      @board.mark(row, column, @current_player.mark)

      if @board.won?
        puts "Well done #{@current_player.name}, you won!"
        puts "Commiserations #{@other_player.name}; better luck next time!"
      elsif @board.draw?
        puts "This game has ended in a draw!"
      else
        switch_players
      end

      @board.draw_board

    end
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







