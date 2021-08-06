class Board
  INITIAL_MARKER = ' '

  def initialize
    @grid = initialize_grid
  end

  def initialize_grid
    fresh_grid = {}
    1.upto(9) do |square_number|
      fresh_grid[square_number] = Square.new(INITIAL_MARKER)
    end
    fresh_grid
  end

  def [](integer)
    @grid[integer].marker
  end

  def []=(integer, marker)
    @grid[integer].marker = marker
  end
end

class Square
  attr_accessor :marker

  def initialize(initial_marker)
    @marker = initial_marker
  end
end

class Player
  attr_reader :marker

  def initialize(name, marker, type = :computer)
    @name = name
    @type = type
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new('Stan', HUMAN_MARKER, :player)
    @computer = Player.new('Steve-O', COMPUTER_MARKER)
  end

  def play
    display_welcome_message
    loop do
      display_board
      human_moves
      display_board
      # break if someone_won? || board_full?

      computer_moves
      display_board
      # break if someone_won? || board_full?
      break
    end
    display_board
    display_goodbye_message
  end

  def human_moves
    puts "Choose a square between 1-9: "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if (1..9).include?(square)

      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[(1..9).to_a.sample] = computer.marker
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts %(
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