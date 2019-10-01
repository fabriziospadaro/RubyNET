require_relative 'grid'
require_relative 'i_network'
class Player < INetwork

  def initialize(grid, position = Point.zero, block_size = 64)
    super()
    @position = position
    @block_size = block_size
    @grid = grid
    draw
  end

  def draw
    @square = Square.new(x: @position.x, y: @position.y, size: @block_size, color: 'black')
  end

  def on_input_detected(key)
    case key
    when 'w'
      @position.y -= 1 * @block_size if @position.y >= @block_size
    when 'a'
      @position.x -= 1 * @block_size if @position.x >= @block_size
    when 's'
      @position.y += 1 * @block_size if @position.y < (@grid.width - 1) * @block_size
    when 'd'
      @position.x += 1 * @block_size if @position.x < (@grid.height - 1) * @block_size
    end
    update_position
    serialize("position", @position)
  end

  def position=(pos)
    @position = pos
    @square.x = pos.x
    @square.y = pos.y
  end

  def update_position(x = nil, y = nil)
    @position.x = x if x
    @position.y = y if y
    @square.x = @position.x
    @square.y = @position.y
  end
end