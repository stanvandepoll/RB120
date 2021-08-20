require 'pry'

module Hand
  MAX_GAME_SCORE = 21

  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
    puts ""
  end

  def total
    raw_sum = cards.sum do |card|
      raw_score(card)
    end

    total_corrected_for_aces(raw_sum)
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > MAX_GAME_SCORE
  end

  private

  def raw_score(card)
    if card.ace? then 11
    elsif card.character? then 10
    else card.face.to_i
    end
  end

  def total_corrected_for_aces(raw_sum)
    sum = raw_sum
    cards.select(&:ace?).count.times do
      sum -= 10 if sum > MAX_GAME_SCORE
    end

    sum
  end
end

class Participant
  include Hand
  attr_accessor :name, :cards

  def initialize
    @cards = []
    set_name
  end
end

class Player < Participant
  def set_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?

      puts "Sorry, must enter a value."
    end
    self.name = name
  end

  def show_flop
    show_hand
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def set_name
    self.name = ROBOTS.sample
  end

  def show_flop
    puts "---- #{name}'s Hand ----"
    puts cards.first
    puts " ?? "
    puts ""
  end
end

class Deck
  SUITS = %w(H D S C)
  FACES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  DECK = SUITS.product(FACES)

  def initialize
    @cards = DECK.shuffle.map do |suit, face|
      Card.new(suit, face)
    end
  end

  def deal_one
    @cards.pop
  end
end

class Card
  SUITS_DESCRIPTORS = {
    'H' => 'Hearts', 'D' => 'Diamonds', 'S' => 'Spades', 'C' => 'Clubs'
  }
  FACES_DESCRIPTORS = {
    'J' => 'Jack', 'Q' => 'Queen', 'K' => 'King', 'A' => 'Ace'
  }

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "The #{face} of #{suit}"
  end

  def face
    FACES_DESCRIPTORS[@face] || @face
  end

  def suit
    SUITS_DESCRIPTORS[@suit]
  end

  def ace?
    face == 'Ace'
  end

  def character?
    king? || queen? || jack?
  end

  def king?
    face == 'King'
  end

  def queen?
    face == 'Queen'
  end

  def jack?
    face == 'Jack'
  end
end

class TwentyOne
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def reset
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def deal_cards
    2.times do
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def player_turn
    puts "#{player.name}'s turn..."

    loop do
      if request_hit_or_stay == 's'
        puts "#{player.name} stays!"
        break
      else
        hit_player
        break if player.busted?
      end
    end
  end

  def request_hit_or_stay
    puts "Would you like to (h)it or (s)tay?"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['h', 's'].include?(answer)
      puts "Sorry, must enter 'h' or 's'."
    end
    answer
  end

  def hit_player
    player.add_card(deck.deal_one)
    puts "#{player.name} hits!"
    player.show_hand
  end

  def dealer_turn
    puts "#{dealer.name}'s turn..."

    loop do
      sleep 2
      break if dealer_subturn
    end
  end

  def dealer_subturn
    if dealer.busted?
      true
    elsif dealer.total >= 17
      puts "#{dealer.name} stays!"
      true
    else
      hit_dealer
      false
    end
  end

  def hit_dealer
    puts "#{dealer.name} hits!"
    dealer.add_card(deck.deal_one)
    dealer.show_hand
  end

  def show_busted
    if player.busted?
      puts "It looks like #{player.name} busted! #{dealer.name} wins!"
    elsif dealer.busted?
      puts "It looks like #{dealer.name} busted! #{player.name} wins!"
    end
  end

  def show_cards
    player.show_hand
    dealer.show_hand
  end

  def show_result
    if player.total > dealer.total
      puts "It looks like #{player.name} wins!"
    elsif player.total < dealer.total
      puts "It looks like #{dealer.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def start
    loop do
      set_up_game

      continuation = perform_game_turns
      continuation && (continuation == :break ? break : next)

      show_cards
      show_result
      play_again? ? reset : break
    end

    puts "Thank you for playing Twenty-One. Goodbye!"
  end

  def set_up_game
    system 'clear'
    deal_cards
    show_flop
  end

  def perform_game_turns
    round_result = nil
    [:player, :dealer].each do |participant|
      round_result = participant_round(participant)
      break if round_result
    end
    round_result
  end

  def participant_round(symbol)
    send("#{participant}_turn")
    if send(participant).busted?
      show_busted
      return :break unless play_again?
      
      reset
      :next
    end
  end
end

game = TwentyOne.new
game.start

