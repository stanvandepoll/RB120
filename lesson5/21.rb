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

  def total(cards)
    raw_sum = cards.sum do |card|
      raw_score(card)
    end

    total_corrected_for_aces(raw_sum, values)
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > MAX_GAME_SCORE
  end

  private

  def raw_score(card)
    case card
    when card.ace? then 11
    when card.character? then 10
    else card.face.to_i
    end
  end

  def total_corrected_for_aces(raw_sum, cards)
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
    puts "#{cards.first}"
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

  def deal
    @cards.pop
  end
end

class Card
  SUITS_DESCRIPTORS = { 'H' => 'Hearts', 'D' => 'Diamonds', 'S' => 'Spades', 'C' => 'Clubs' }
  FACES_DESCRIPTORS = { 'J' => 'Jack', 'Q' => 'Queen', 'K' => 'King', 'A' => 'Ace' }

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

class Game
  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start

