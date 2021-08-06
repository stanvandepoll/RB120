class TTTGame
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

  end
end

game = TTTGame.new
game.play

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
end

class Square
  def initialize
    @state = ''
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