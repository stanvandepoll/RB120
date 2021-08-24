class RPSGame
  MAX_SCORE = 10
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    reset_score
  end

  def play
    display_welcome_message

    loop do
      play_game
      display_game_winner
      break unless play_again?

      reset_score
    end

    display_goodbye_message
  end

  private

  def play_game
    loop do
      play_round
      break if max_score_reached?

      clear_screen
    end
  end

  def play_round
    display_score
    human.choose
    computer.choose
    display_moves
    display_round_winner
    adjust_score
    sleep 1
  end

  def clear_screen
    system 'clear'
  end

  def reset_score
    @score = { @human => 0, @computer => 0 }
  end

  def display_welcome_message
    puts "Welcome to #{game_name}!"
  end

  def display_goodbye_message
    puts "Thanks for playing #{game_name}. Good bye!"
  end

  def game_name
    Move::VALUES.map(&:capitalize).join(', ')
  end

  def display_round_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_game_winner
    winner = @score.key(MAX_SCORE)
    puts "#{winner.name} won this game!"
  end

  def adjust_score
    if human.move > computer.move
      @score[human] += 1
    elsif human.move < computer.move
      @score[computer] += 1
    end
  end

  def display_score
    puts "Current score: "
    scores_string = @score.map do |player, score|
      "#{player.name}: #{score}"
    end.join(', ')
    puts scores_string
  end

  def max_score_reached?
    @score.values.any? { |score| score >= MAX_SCORE }
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase

      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts "Please choose #{Move::VALUES.join(', ')}."
      choice = gets.chomp
      break if Move::VALUES.include?(choice)

      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end

  private

  def set_name
    chosen_name = nil
    loop do
      puts "What's your name?"
      chosen_name = gets.chomp
      break unless chosen_name.empty?

      puts "Sorry, must enter a value."
    end

    self.name = chosen_name
  end
end

class Computer < Player
  def initialize
    @moves = Move.generate_values_collection
    super
  end

  def choose
    self.move = Move.new(@moves.sample)
  end

  private

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end
end

class Move
  VALUES = %w(rock paper scissors lizard spock)
  WINNING_COMBINATIONS = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'spock'],
    'spock' => ['scissors', 'rock']
  }

  include Comparable

  def initialize(value)
    @value = value
  end

  def self.generate_values_collection
    VALUES.map do |value|
      [value] * rand(5)
    end.flatten
  end

  def to_s
    value
  end

  def <=>(other_move)
    return 0 if value == other_move.value
    return 1 if wins_from?(other_move)
    -1
  end

  def wins_from?(other_move)
    WINNING_COMBINATIONS[value].include?(other_move.value)
  end

  protected

  attr_reader :value
end

RPSGame.new.play
