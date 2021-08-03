class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end

    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_winner
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"

    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end

    # case human.move
    # when 'rock'
    #   puts "It's a tie!" if computer.move == 'rock'
    #   puts "#{human.name} won!" if computer.move == 'scissors'
    #   puts "#{computer.name} won!" if computer.move == 'paper'
    # when 'paper'
    #   puts "It's a tie!" if computer.move == 'paper'
    #   puts "#{human.name} won!" if computer.move == 'rock'
    #   puts "#{computer.name} won!" if computer.move == 'scissors'
    # when 'scissors'
    #   puts "It's a tie!" if computer.move == 'scissors'
    #   puts "#{human.name} won!" if computer.move == 'paper'
    #   puts "#{computer.name} won!" if computer.move == 'rock'
    # end
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

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)

      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def >(other_move)
    case
    when rock?
      other_move.scissors?
    when paper?
      other_move.rock?
    when scissors?
      other_move.paper?
    end
  end

  def <(other_move)
    case
    when rock?
      other_move.paper?
    when paper?
      other_move.scissors?
    when scissors?
      other_move.rock?
    end
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# not sure where "compare" goes yet
def compare(move1, move2)

end

RPSGame.new.play