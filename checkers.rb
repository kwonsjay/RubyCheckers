require './pieces'
require './board'

class Checkers
  
  def initialize
    @board = Board.new
    @win_flag = false
    @black = true
  end
  
  def play
    
  end
  
end


b = Board.new
b.display
b.delete([7, 6])
b.display
b.move([5, 4], [4, 3])
b.display
b.move([2, 1], [3, 2])
b.display
b.move([3, 2], [5, 4])
b.display
b.move([5, 4], [7, 6])
b.display
p b[[7, 6]].possible_moves
b.move([7, 6], [6, 5])
b.display
p b[[6, 5]].possible_moves
b.move([6, 5], [4, 7])
b.display
b.move([4, 7], [3, 6])
b.display
p b[[3, 6]].possible_moves