module Hand
  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Player
  include Hand

  def initialize
    # what would the "data" or "states" of a Player object entail?
    # maybe cards? a name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end

class Dealer
  include Hand

  def initialize
    # seems like very similar to Player... do we even need this?
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

