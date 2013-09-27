require './pieces'
require './board'

class Checkers
  
  attr_accessor :board, :current, :previous, :black, :jumped
  
  def initialize
    @board = Board.new
    @previous = :red
    @current = :black
    @black = true
    @jumped = false
  end
  
  def play
    game_over = false
    introduction
    
    until game_over
      self.jumped = false
      start_loc = set_start
      new_loc = set_target(start_loc)
      if @jumped
        until new_loc.jump_moves.empty?
          new_loc = chain_jumps(new_loc)
        end
      end
      self.previous = @current
      next_turn
      game_over = board.wipeout?(@current) || board.stuck?(@current)
    end
    puts "Winner is #{previous}!"
  end
  
  def introduction
    puts "Welcome to Checkers!"
    @board.display
  end
  
  def set_start
    puts "#{@current.to_s}, choose your piece."
    start_loc = gets.chomp.split(" ").map(&:to_i)
    until @board[start_loc].is_a?(Piece) && @board.same_color?(start_loc, @current)
      puts "NO. Try again."
      start_loc = gets.chomp.split(" ").map(&:to_i)
    end
    start_loc
  end
  
  def set_target(start_loc)
    begin
      puts "#{@current.to_s}, choose target location."
      target_loc = gets.chomp.split(" ").map(&:to_i)
      self.jumped = @board.move(@current, start_loc, target_loc)
    rescue
      puts "NO. Try again."
      retry
    end
    @board[target_loc]
  end
  
  def chain_jumps(piece)
    begin
      @board.display
      puts "#{@current.to_s}, you can chain more jumps."
      target_loc = gets.chomp.split(" ").map(&:to_i)
      @board.move(@current, piece.position, target_loc) if piece.jump_moves.include?(target_loc)
    rescue
      puts "NO. Try again."
      retry
    end
    @board[target_loc]
  end
  
  def next_turn
    self.black = !black
    self.current = @black ? :black : :red
    board.display
  end
  
end


c = Checkers.new
c.play