require 'colorize'
require './pieces'
require './error'

class Board
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    set_pieces
  end
  
  def set_pieces
    [:black, :red].each do |color|
      place_units(color)
    end
  end
  
  def place_units(color)
    row_range = (color == :black) ? (5..7) : (0..2)
    col_range = (0..7)
    row_range.each do |row_index|
      col_range.each do |col_index|        
        if (row_index.odd? && col_index.even?) || (row_index.even? && col_index.odd?)
          self.grid[row_index][col_index] = Piece.new(self, [row_index, col_index], color)
        end
      end
    end
  end
  
  def[](position)
    raise InvalidPositionError.new, "Coordinates out of bounds" unless valid?(position)
    x, y = position
    @grid[x][y]
  end
  
  def[]=(position, piece)
    raise InvalidPositionError.new, "Coordinates out of bounds" unless valid?(position)
    x, y = position
    @grid[x][y] = piece
  end
  
  def increment(start_loc, vector)
    [start_loc, vector].transpose.map { |el| el.reduce(&:+) }
  end
  
  def difference(target_loc, start_loc)
    [target_loc, start_loc].transpose.map { |el| el.reduce(&:-) }
  end
  
  def empty?(abs_position)
    self[abs_position].nil?
  end
  
  def promote_king(target_loc)
    promote_condition = (self[target_loc].color == :black) ? 0 : 7
    if target_loc.first == promote_condition
      self[target_loc].king = true
      puts "A new King emerges."
    end
  end
  
  def jumped?(start_loc, diff)
    !self[start_loc].vectors.include?(diff)
  end
  
  def delete_jumped_piece(abs_position, diff)
    del_position = increment(abs_position, diff.map { |el| el / 2 })
    self[del_position] = nil
  end
  
  def delete(position)
    self[position] = nil
  end
  
  def valid?(position)
    position.all? { |num| num.between?(0, 7) }
  end
  
  def same_color?(position, color)
    self[position].color == color
  end
  
  def move(color, start_loc, target_loc)
    jumped = false
    raise InvalidMoveError.new, "Invalid coordinates" unless valid?(start_loc) && valid?(target_loc)
    raise InvalidMoveError.new, "Can't move there." unless self[start_loc].possible_moves.include?(target_loc)
    raise InvalidMoveError.new, "Wrong color." unless self[start_loc].color == color
    diff = difference(target_loc, start_loc)
    if jumped?(start_loc, diff)
      delete_jumped_piece(start_loc, diff)
      jumped = true
    end
    self[start_loc].move(target_loc)
    promote_king(target_loc)
    jumped
  end
  
  def wipeout?(color)
    grid.each_index do |row_index|
      grid.each_index do |col_index|
        check = grid[row_index][col_index]
        next if check.nil?
        return false if check.color == color
      end
    end
    return true
  end
  
  def stuck?(color)
    total_moves = []
    grid.each_index do |row_index|
      grid.each_index do |col_index|
        check = grid[row_index][col_index]
        next if check.nil?
        total_moves << check.possible_moves
      end
    end
    total_moves.empty?
  end
  
  def display
    puts "   0   1   2   3   4   5   6   7".white
    grid.each_with_index do |row, index|
      print "#{index}".white
      col = 0
      row.each do |piece|
        color = (index.even? && col.odd?) || (index.odd? && col.even?) ? :light_white : :white
        print piece.is_a?(Piece) ? piece.render.colorize(background: color) : "    ".colorize(background: color)
        col += 1
      end
      puts ""
    end
    puts "\n---------------------------------".white
  end
  
end