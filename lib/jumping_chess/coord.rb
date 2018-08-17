=begin
                00
              01  11
            02  12  22
          03  13  23  33
        04  14  24  34  44
      05  15  25  35  45  55
    06  16  26  36  46  56  66
  07  17  27  37  47  57  67  77
08  18  28  38  48  58  68  78  88
  19  29  39  49  59  69  79  89
    2a  3a  4a  5a  6a  7a  8a
      3b  4b  5b  6b  7b  8b
        4c  5c  6c  7c  8c
          5d  6d  7d  8d
            6e  7e  8e
              7f  8f
                8g
=end

CAMP = 4
HALF = 9
MIDDLE_Y = 8

class Coord
  attr_reader :x, :y
  attr_accessor :index, :direct_neighbors, :jump_neighbors, :direct_and_jump_neighbors

  def self.find(x, y)
    ALL_COORDS.find { |coord| coord.x == x and coord.y == y }
  end

  def initialize(x, y)
    @x, @y = x, y
  end

  def distance(to)
    (@y - to.y).abs
  end

  def inspect
    "#{hepta(x)}#{hepta(y)}"
  end
  alias :to_s :inspect

  private def hepta(n)
    n <= 9 ? n.to_s : ('a'.ord + (n-10)).chr
  end
end

BOARD = (0...HALF).map { |y|
  (0..y).map { |x| Coord.new(x,y) }
} + (0...HALF-1).map { |i|
  (0...HALF-1-i).map { |x| Coord.new(i+1+x,HALF+i) }
}
BOARD.each(&:freeze).freeze

NEIGHBORS = [
  #  \       /        -
  [-1,-1], [0,-1], [+1,0],
  [+1,+1], [0,+1], [-1,0],
]

ALL_COORDS = BOARD.reduce(:+)
ALL_COORDS.each_with_index { |coord, index|
  coord.index = index

  x, y = coord.x, coord.y
  coord.direct_neighbors = NEIGHBORS.map { |dx, dy|
    Coord.find(coord.x + 1*dx, coord.y + 1*dy)
  }.compact.freeze

  coord.jump_neighbors = NEIGHBORS.map { |dx, dy|
    direct = Coord.find(coord.x + 1*dx, coord.y + 1*dy)
    jump = Coord.find(coord.x + 2*dx, coord.y + 2*dy)
    [direct, jump] if direct and jump
  }.compact.freeze

  coord.direct_and_jump_neighbors = NEIGHBORS.map { |dx, dy|
    direct = Coord.find(coord.x + 1*dx, coord.y + 1*dy)
    jump = Coord.find(coord.x + 2*dx, coord.y + 2*dy)
    [direct, jump] if direct
  }.compact.freeze
}
ALL_COORDS.each(&:freeze)

COORDS_BY_NAME = {}
ALL_COORDS.each { |coord| COORDS_BY_NAME[coord.to_s] = coord }
