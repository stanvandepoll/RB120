class Board
  def initialize
    @grid = initialize_grid
  end

  def initialize_grid
    fresh_grid = {}
    1.upto(9) do |square_number|
      fresh_grid[square_number] = Square.new
    end
    fresh_grid
  end

  def [](integer)
    @grid[integer]
  end
end

class Square
  def initialize
    @state = ''
  end

  def to_s
    @state
  end
end

class Player
  def initialize(name, marker, type = :computer)
    @name = name
    @type = type
    @marker = marker
  end

  def mark

  end
end

class TTTGame
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_won? || board_full?

      second_player_moves
      break if someone_won? || board_full?
    end
    display_result
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_method
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    %(
  (1)|(2)|(3)
   #{board[1]} | #{board[2]} | #{board[3]}
     |   |
  ---+---+---
  (4)|(5)|(6)
   #{board[4]} | #{board[5]} | #{board[6]}
     |   |
  ---+---+---
  (7)|(8)|(9)
   #{board[7]} | #{board[8]} | #{board[9]}
     |   |
  )
  end
end

game = TTTGame.new
game.play