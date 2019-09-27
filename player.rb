require_relative 'grid'
require_relative 'i_network'
class Player < INetwork

  def initialize(grid, position = Point.zero, placeholder = "O")
    @grid = grid
    @position = position
    @placeholder = placeholder
  end

  def draw
    @grid.set(@position, @placeholder)
  end

  def update_position(x, y)
    @position.x = x
    @position.y = y
  end

  def on_input_detected(key)
    case key
    when 'w'
      @position.y -= 1 if @position.y > 0
    when 'a'
      @position.x -= 1 if @position.x > 0
    when 's'
      @position.y += 1 if @position.y < @grid.height - 1
    when 'd'
      @position.x += 1 if @position.x < @grid.width - 1
    end
  end
end