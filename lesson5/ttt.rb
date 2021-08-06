class Board
  INITIAL_MARKER = ' '
  HORIZONTAL_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  VERTICAL_LINES = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
  DIAGONAL_LINES = [[1, 5, 9], [3, 5, 7]]
  WINNING_LINES = HORIZONTAL_LINES + VERTICAL_LINES + DIAGONAL_LINES

  def initialize
    reset
  end

  def reset
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
        line_markings = @grid.values_at(*line).map(&:marker)
        return player if line_markings.count(player_marker) == 3
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
    clear_screen
    display_welcome_message

    loop do
      display_board(false)

      loop do
        human_moves
        break if someone_won? || board_full?

        computer_moves
        break if someone_won? || board_full?

        display_board
      end
      display_board
      display_result
      break unless play_again?

      board.reset
      clear_screen
      puts "Let's play again!"
    end
    display_goodbye_message
  end

  def clear_screen
    system 'clear'
  end

  def play_again?
    answer = nil
    puts "Would you like to play again? (y/n)"

    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)

      puts "Sorry, you must enter y or n."
    end

    answer == 'y'
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

  def display_board(clear_system = true)
    clear_screen() if clear_system
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