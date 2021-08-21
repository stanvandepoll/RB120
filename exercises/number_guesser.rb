require 'pry'

class GuessingGame
  def initialize
    @guesses_remaining = 7
    @number = generate_number_to_guess
  end

  def play
    loop do
      guessed_number = guess_number
      guess_result = check_number(guessed_number)
      display_guess_result(guess_result)
      break if guess_result.zero?
      break unless guesses_remaining?
    end
  end

  private

  def generate_number_to_guess
    (1..100).to_a.sample
  end

  def guesses_remaining?
    @guesses_remaining.positive?
  end

  def guess_number
    puts "You have #{@guesses_remaining} guesses remaining."
    guessed_number = nil
    loop do
      puts "Enter a number between 1 and 100:"
      guessed_number = gets.chomp
      break if valid_guess?(guessed_number)

      p "Invalid guess "
    end

    @guesses_remaining -= 1
    guessed_number.to_i
  end

  def valid_guess?(guessed_number)
    (1..100).cover?(guessed_number.to_i) &&
      guessed_number.to_i.to_s == guessed_number
  end

  def check_number(guessed_number)
    guessed_number <=> @number
  end

  def display_guess_result(guess_result)
    result_string =
      case guess_result
      when -1 then 'Your guess is too low'
      when 1 then 'Your guess is too high'
      when 0 then "That's the number!\n\nYou won!"
      end
    puts result_string
  end
end

game = GuessingGame.new
game.play