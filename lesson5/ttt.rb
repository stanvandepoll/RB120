class Board
  INITIAL_MARKER = ' '
  HORIZONTAL_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  VERTICAL_LINES = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
  DIAGONAL_LINES = [[1, 5, 9], [3, 5, 7]]
  WINNING_LINES = HORIZONTAL_LINES + VERTICAL_LINES + DIAGONAL_LINES

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

  def unmarked_keys
    @grid.keys.select { |key| @grid[key].marker == INITIAL_MARKER }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?(players)
    !!detect_winner(players)
  end

  def detect_winner(players)
    players.each do |player|
      player_marker = player.marker
      WINNING_LINES.each do |line|
        return player if @grid.values_at(*line).all? { |square| square.marker == player_marker }
      end
    end
    nil
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
      break if someone_won? || board_full?

      computer_moves
      break if someone_won? || board_full?
    end
    display_board
    display_result
    display_goodbye_message
  end

  def board_full?
    @board.full?
  end

  def someone_won?
    @board.someone_won?([human, computer])
  end

  def human_moves
    puts "Choose a square number (#{board.unmarked_keys.join(', ')})."
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    system 'clear'
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
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

  def display_result
    case board.detect_winner([human, computer])
    when human
      puts "You won!"
    when computer
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end
end

game = TTTGame.new
game.play