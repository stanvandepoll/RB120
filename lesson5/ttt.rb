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

  def play

  end
end