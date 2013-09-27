class InvalidPositionError < StandardError
  def initialize(msg = "Invalid Position Error")
    super(msg)
  end
end

class InvalidMoveError < StandardError
  def initialize(msg = "Invalid Move Error")
    super(msg)
  end
end
