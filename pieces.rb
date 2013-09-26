require 'colorize'

class Piece
  attr_accessor :position, :color, :king, :board
  PAWN_MARKER = {
    :black => " \u25CE  ".black,
    :red   => " \u25CE  ".red
  }
  
  KING_MARKER = {
    :black => " \u25C9  ".black,
    :red   => " \u25C9  ".red
  }
  
  MOVE_VECTORS = [
    [ 1,  1],
    [ 1, -1],
    [-1,  1],
    [-1, -1]
  ]
  
  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
    @king = false
  end
  
  def move(target_loc)
    board[self.position] = nil
    self.position = target_loc
    board[target_loc] = self
  end
  
  def vectors
    if self.king
      MOVE_VECTORS
    else
      if self.color == :black
        MOVE_VECTORS[2..-1]
      else
        MOVE_VECTORS[0...2]
      end
    end
  end
  
  def increment(start_loc, vector)
    [start_loc, vector].transpose.map { |el| el.reduce(&:+) }
  end
  
  def possible_moves
    possible_moves = []
    self.vectors.each do |vector|
      abs_position = increment(position, vector)
      next unless @board.valid?(abs_position)
      if @board[abs_position].nil?
        possible_moves << abs_position
      elsif @board[abs_position].color != @color
        jump_move = possible_jump(abs_position, vector)
        possible_moves << jump_move unless jump_move.empty?
      end
    end
    possible_moves
  end
  
  def possible_jump(abs_position, vector)
    jump_position = increment(abs_position, vector)
    return jump_position if @board.valid?(jump_position) && @board.empty?(jump_position)
    return []
  end
    
  def render
    if @king
      KING_MARKER[@color]
    else
      PAWN_MARKER[@color]
    end
  end
  
end