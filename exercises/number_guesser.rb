require 'pry'

class GuessingGame
  RESULT_OF_GUESS_MESSAGE = {
    high:  "Your number is too high.",
    low:   "Your number is too low.",
    match: "That's the number!"
  }.freeze
  RESULT_OF_GAME_MESSAGE = {
    win:  "You won!",
    lose: "You have no more guesses. You lost!"
  }.freeze

  def initialize(lower_bound, upper_bound)
    @range = (lower_bound..upper_bound)
    @max_guesses = Math.log2(upper_bound - lower_bound).to_i + 1
    @secret_number = nil
  end

  def play
    reset
    game_result = play_game
    display_game_end_message(game_result)
  end

  private

  def reset
    @guesses_remaining = @max_guesses
    @secret_number = generate_secret_number
  end

  def play_game
    loop do
      guessed_number = guess_number
      guess_result = determine_guess_result(guessed_number)
      display_guess_result(guess_result)
      break :win if guess_result == :match
      break :lose unless guesses_remaining?
    end
  end

  def generate_secret_number
    @range.to_a.sample
  end

  def guesses_remaining?
    @guesses_remaining.positive?
  end

  def guess_number
    puts "You have #{@guesses_remaining} guesses remaining."
    guessed_number = nil
    loop do
      puts "Enter a number between #{@range.min} and #{@range.max}:"
      guessed_number = gets.chomp
      break if valid_guess?(guessed_number)

      p "Invalid guess "
    end

    @guesses_remaining -= 1
    guessed_number.to_i
  end

  def valid_guess?(guessed_number)
    @range.cover?(guessed_number.to_i) &&
      guessed_number.to_i.to_s == guessed_number
  end

  def check_number(guessed_number)
    guessed_number <=> @secret_number
  end

  def determine_guess_result(guessed_number)
    case check_number(guessed_number)
    when -1 then :low
    when 1 then :high
    when 0 then :match
    end
  end

  def display_guess_result(guess_result)
    puts RESULT_OF_GUESS_MESSAGE[guess_result]
  end

  def display_game_end_message(game_result)
    puts "", RESULT_OF_GAME_MESSAGE[game_result]
  end
end

game = GuessingGame.new(501, 1500)
game.play
game.play