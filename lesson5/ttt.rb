require 'pry'

class Board
  INITIAL_MARKER = ' '
  MIDDLE_SQUARE = 5
  LINE_LENGTH = 3
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
      fresh_grid[square_number] = Square.new(initial_marker)
    end
    fresh_grid
  end

  def [](integer)
    @grid[integer].marker
  end

  def []=(integer, marker)
    @grid[integer].marker = marker
  end

  def values_at(*square_numbers)
    square_numbers.map { |square_number| self[square_number] }
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
    @grid.keys.select { |key| @grid[key].marker == initial_marker }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    markers = @grid.values.map(&:marker).uniq - [initial_marker]
    markers.each do |marker|
      WINNING_LINES.each do |line|
        line_markings = @grid.values_at(*line).map(&:marker)
        return marker if line_markings.count(marker) == line_length
      end
    end
    nil
  end

  def middle_square
    MIDDLE_SQUARE
  end

  def line_length
    LINE_LENGTH
  end

  def initial_marker
    INITIAL_MARKER
  end
end

class Square
  attr_accessor :marker

  def initialize(initial_marker)
    @marker = initial_marker
  end
end

class Player
  attr_reader :marker, :name

  def initialize(marker, name)
    @marker = marker
    @name = name
  end
end

class TTTGame
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(input_marker, input_name)
    @computer = Player.new(COMPUTER_MARKER, 'Nemesis')
    @previous_starter = nil
    @starter_setting = input_starter_setting
    @current_player = pick_starter
    @score = { @human => 0, @computer => 0 }
    @max_score = 2
  end

  def play
    clear_screen
    display_welcome_message
    outer_game_loop
    display_goodbye_message
  end

  private

  def outer_game_loop
    loop do
      main_game
      show_outer_loop_result
      break unless play_again?

      reset_outer_loop
      display_play_again_message
    end
  end

  def main_game
    loop do
      display_board

      players_move_till_result
      clear_screen_and_display_board
      display_result
      update_score
      break if max_score_reached?

      reset_main_game
      display_next_game_message
    end
  end

  def players_move_till_result
    loop do
      current_player_moves
      break if someone_won? || board_full?

      switch_players
      clear_screen_and_display_board if human_turn?
    end
  end

  def input_starter_setting
    puts 'Who may start? h = human, c = computer, a = alternate, r = random'

    starter_choice = ''
    loop do
      starter_choice = gets.chomp.downcase.to_sym
      break if %i(h c a r).include?(starter_choice)

      puts 'Invalid choice, please choose again'
    end

    starter_translation = { h: :human, c: :computer, a: :alternate, r: :random }
    starter_translation[starter_choice]
  end

  def input_marker
    puts "Enter your one-character marker"
    marker = nil
    loop do
      marker = gets.chomp
      break if marker.size == 1 && marker != COMPUTER_MARKER && marker != board.initial_marker

      puts 'Invalid choice, please choose again'
    end

    marker
  end

  def input_name
    puts "Enter your name"

    gets.chomp
  end

  def pick_starter
    starter_symbol = case @starter_setting
      when :human then :human
      when :computer then :computer
      when :alternate
        if @previous_starter
          @previous_starter == :human ? :computer : :human
        else
          %i(human computer).sample
        end
      when :random
        %i(human computer).sample
      end

    @previous_starter = starter_symbol
    send(starter_symbol)
  end

  def max_score_reached?
    @score.values.max == @max_score
  end

  def show_outer_loop_result
    puts "Final score is #{human.name}: #{@score[human]}, #{computer.name}: #{@score[computer]}."
  end

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

  def reset_outer_loop
    reset_main_game
    reset_score
  end

  def reset_main_game
    board.reset
    @current_player = pick_starter
    clear_screen
  end

  def reset_score
    @score = { @human => 0, @computer => 0 }
  end

  def display_play_again_message
    puts "Let's play again!"
  end

  def display_next_game_message
    puts "On to the next game."
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
    board.full?
  end

  def someone_won?
    board.someone_won?
  end

  def human_moves
    puts "Choose a square number (#{join_or(board.unmarked_keys)})."
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def join_or(array, delimiter=', ', end_word='or')
    case array.size
    when 0 then ''
    when 1 then array.first
    when 2 then array.join(" #{end_word} ")
    else array[0..-2].join(delimiter) + "#{delimiter}#{end_word} #{array.last}"
    end
  end

  def computer_moves
    return if perform_line_completion_move!(computer.marker)
    return if perform_line_completion_move!(human.marker)

    if board.unmarked_keys.include?(board.middle_square)
      board[board.middle_square] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def perform_line_completion_move!(marker)
    at_risk_square = square_at_risk(marker)
    if at_risk_square
      board[at_risk_square] = computer.marker
      true
    else
      false
    end
  end

  def square_at_risk(marker)
    square_number = nil

    board.class::WINNING_LINES.each do |line|
      square_number = at_risk_square_in(
        line: line, marker: marker
      )
      break if square_number
    end

    square_number
  end

  def at_risk_square_in(line:, marker:)
    line_values = board.values_at(*line)
    if line_values.count(marker) == (board.line_length - 1) &&
       line_values.count(board.initial_marker) == 1
      at_risk_line_index = line_values.index(board.initial_marker)
      line[at_risk_line_index]
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts rules_and_score_header 
    puts ''
    puts board.draw
    puts ''
  end

  def rules_and_score_header 
    %(
    -------------------
        TIC TAC TOE
    -------------------
    #{human.name} marks with a #{human.marker}, #{computer.name} is #{computer.marker}.
    Win #{@max_score} rounds to win the whole game.
    Rounds won; you: #{@score[human]}, #{computer.name}: #{@score[computer]}
    -------------------
    )
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

  def update_score
    case board.winning_marker
    when human.marker
      @score[human] += 1
    when computer.marker
      @score[computer] += 1
    end
  end
end

game = TTTGame.new
game.play
