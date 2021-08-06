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

  def draw
    %(
      (1)|(2)|(3)
       #{self[1]} | #{self[2]} | #{self[3]}
         |   |
      ---+---+---
      (4)|(5)|(6)
       #{self[4]} | #{self[5]} | #{self[6]}
         |   |
      ---+---+---
      (7)|(8)|(9)
       #{self[7]} | #{self[8]} | #{self[9]}
         |   |
    )
  end

  def unmarked_keys
    @grid.keys.select { |key| @grid[key].marker == INITIAL_MARKER }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?(players)
    !!winning_marker
  end

  def winning_marker
    markers = @grid.values.map(&:marker).uniq - [INITIAL_MARKER]
    markers.each do |marker|
      WINNING_LINES.each do |line|
        line_markings = @grid.values_at(*line).map(&:marker)
        return marker if line_markings.count(marker) == 3
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
  FIRST_TO_MOVE = :human

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new('Stan', HUMAN_MARKER, :player)
    @computer = Player.new('Steve-O', COMPUTER_MARKER)
    @current_player = self.send(FIRST_TO_MOVE)
  end

  def play
    clear_screen
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        switch_players
        break if someone_won? || board_full?

        clear_screen_and_display_board if human_turn?
      end
      clear_screen_and_display_board
      display_result
      break unless play_again?

      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def current_player_moves
    if human_turn?
      human_moves
    else
      computer_moves
    end
  end

  def switch_players
    @current_player = (human_turn? ? @computer : @human)
  end

  def human_turn?
    @current_player == @human
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def clear_screen
    system 'clear'
  end

  def reset
    board.reset
    @current_player = self.send(FIRST_TO_MOVE)
    clear_screen
  end

  def display_play_again_message
    puts "Let's play again!"
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

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ''
    puts board.draw
    puts ''
  end

  def display_result
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end
end

game = TTTGame.new
game.play