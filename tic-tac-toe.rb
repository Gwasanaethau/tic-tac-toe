#========
# CELL
#========

class Cell
  attr_accessor :mark
  @@id_count = 1
  def initialize(mark = ' ')
    @mark = mark
    @id = @@id_count
    @@id_count += 1
  end

  def to_s
    if @mark == ' '
      "\e[31m#{@id}\e[0m" # \e[31m is ASCII colour escape sequence for red. \e[0m returns the colour to default.
    else
      @mark
    end
  end

  def ==(cell)
    @mark == cell.mark
  end

  def eql?(cell)
    @mark == cell.mark
  end

  def hash
    @mark.hash
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
  def initialize
    @grid = default_grid
  end

  def mark(row, column, player_mark)
    if @grid[row][column].mark == ' '
      @grid[row][column].mark = player_mark
      true
    else
      puts 'That position has already been taken, please choose again!'
      false
    end
  end

  def draw_board
    puts @grid[0][0].to_s + '|' + @grid[0][1].to_s + '|' + @grid[0][2].to_s
    puts '–+–+–'
    puts @grid[1][0].to_s + '|' + @grid[1][1].to_s + '|' + @grid[1][2].to_s
    puts '–+–+–'
    puts @grid[2][0].to_s + '|' + @grid[2][1].to_s + '|' + @grid[2][2].to_s
  end

  def won?
=begin
    Yeah, this is horrible, but it works, so it’s staying for the moment! S;-Þ
    It is essentially checking each row, column and diagonal for winning moves
    and making sure they are not winning moves of empty cells!
    @grid[0][0].mark != ' ' && @grid[0][0].mark == @grid[0][1].mark && @grid[0][1].mark == @grid[0][2].mark ||
    @grid[1][0].mark != ' ' && @grid[1][0].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[1][2].mark ||
    @grid[2][0].mark != ' ' && @grid[2][0].mark == @grid[2][1].mark && @grid[2][1].mark == @grid[2][2].mark ||
    @grid[0][0].mark != ' ' && @grid[0][0].mark == @grid[1][0].mark && @grid[1][0].mark == @grid[2][0].mark ||
    @grid[0][1].mark != ' ' && @grid[0][1].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[2][1].mark ||
    @grid[0][2].mark != ' ' && @grid[0][2].mark == @grid[1][2].mark && @grid[1][2].mark == @grid[2][2].mark ||
    @grid[0][0].mark != ' ' && @grid[0][0].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[2][2].mark ||
    @grid[0][2].mark != ' ' && @grid[0][2].mark == @grid[1][1].mark && @grid[1][1].mark == @grid[2][0].mark
=end
    @grid.any? do |row|
      row.first.mark != ' ' && row.uniq.length == 1
    end ||
    @grid.transpose.any? do |column|
      column.first.mark != ' ' && column.uniq.length == 1
    end ||
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
  def initialize(players=[], board=Board.new)
    @board = board
    if players.length == 0
      players << create_player('Player 1', '×')
      players << create_player('Player 2', '∘')
    end
    @current_player, @other_player = players.shuffle
  end

  def play
    @board.draw_board

    until @board.won? || @board.draw?

      row, column = get_mark_coords
      until @board.mark(row, column, @current_player.mark)
        row, column = get_mark_coords
      end

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

  def create_player(default_name, default_mark)
    puts "#{default_name}: what is your name? (<RETURN> for #{default_name})"
    name = gets.chomp
    name = default_name if name == ''
    puts "So, #{name}, what symbol do you want to use? (<RETURN> for #{default_mark})"
    mark = gets.chomp.chr
    mark = default_mark if mark == ''
    Player.new( { :name => name, :mark => mark } )
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def get_mark_coords
    puts "#{@current_player.name}: you’re up!"
    puts "Select a slot to place your #{@current_player.mark} in."

    slot = gets.chomp.to_i - 1 #FIXME: Assumes input is in correct format for the moment…
    puts

    row = slot / 3
    column = slot % 3
    return row, column
  end
end

#========
# MAIN
#========

Game.new.play







